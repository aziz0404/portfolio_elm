<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class PagesController extends AbstractController
{
    /**
     * @Route("/", name="app_home")
     */
    public function index(): Response
    {
        return $this->render('pages/home.html.twig');
    }

     /**
     * @Route("/presentation", name="app_pages_presentation")
     */
    public function presentation(): Response
    {
        return $this->render('pages/presentation.html.twig');
    }

    /**
     * @Route("/contact", name="app_pages_contact")
     */
    public function contact(): Response
    {
        return $this->render('pages/contact.html.twig');
    }
}
