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

# Enable Apache mod_rewrite
RUN a2enmod rewrite

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

# Install PHP dependencies WITH dev (needed for WebProfilerBundle & DebugBundle)
RUN composer install --optimize-autoloader --no-scripts

# Run post-install scripts (ignore errors)
RUN composer run-script post-install-cmd || true

# Set NODE_OPTIONS for old Node.js compatibility
ENV NODE_OPTIONS=--openssl-legacy-provider

# Install Node dependencies and build assets
RUN npm install --legacy-peer-deps && npm run build

# Create var directory and set permissions
RUN mkdir -p /var/www/html/var && \
    chown -R www-data:www-data /var/www/html/var /var/www/html/public

# Configure Apache DocumentRoot and Directory
RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf && \
    echo '<Directory /var/www/html/public>' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    AllowOverride All' >> /etc/apache2/sites-available/000-default.conf && \
    echo '    Require all granted' >> /etc/apache2/sites-available/000-default.conf && \
    echo '</Directory>' >> /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]