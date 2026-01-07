FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Configure PHP pour masquer les warnings de dépréciation
RUN echo "error_reporting = E_ERROR | E_PARSE" > /usr/local/etc/php/conf.d/custom-php.ini && \
    echo "display_errors = Off" >> /usr/local/etc/php/conf.d/custom-php.ini && \
    echo "display_startup_errors = Off" >> /usr/local/etc/php/conf.d/custom-php.ini

# Enable Apache mod_rewrite and set ServerName
RUN a2enmod rewrite && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Set working directory
WORKDIR /var/www/html

# Copy composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Set environment to production
ENV APP_ENV=prod
ENV APP_DEBUG=0

# Ignore les warnings PHP pendant l'installation
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV SYMFONY_DEPRECATIONS_HELPER=disabled

# Install PHP dependencies WITH dev (needed for annotations)
RUN composer install --optimize-autoloader --no-scripts 2>&1 | grep -v "Deprecated:" || true

# Run post-install scripts (ignore deprecation warnings)
RUN composer run-script post-install-cmd 2>&1 | grep -v "Deprecated:" || true

# Set NODE_OPTIONS for old Node.js compatibility
ENV NODE_OPTIONS=--openssl-legacy-provider

# Install Node dependencies and build assets
RUN npm install --legacy-peer-deps && npm run build

# Create var directory with proper permissions
RUN mkdir -p /var/www/html/var /var/www/html/var/cache /var/www/html/var/log && \
    chown -R www-data:www-data /var/www/html/var /var/www/html/public && \
    chmod -R 775 /var/www/html/var

# Clear and warmup cache for production
RUN php bin/console cache:clear --env=prod 2>&1 | grep -v "Deprecated:" || true && \
    php bin/console cache:warmup --env=prod 2>&1 | grep -v "Deprecated:" || true

# Configure Apache DocumentRoot and Directory
RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf && \
    echo '<Directory /var/www/html/public>' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    AllowOverride All' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    Require all granted' >> /etc/apache2/sites-available/000-default.conf && \
    echo '</Directory>' >> /etc/apache2/sites-available/000-default.conf

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80

CMD ["apache2-foreground"]