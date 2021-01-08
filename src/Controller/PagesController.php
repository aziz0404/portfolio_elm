<?php

namespace App\Controller;

use App\Form\ContactFormType;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Bridge\Twig\Mime\TemplatedEmail;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Mailer\MailerInterface;

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
    public function contact(Request $request, MailerInterface $mailer): Response
    {
        $form = $this->createForm(ContactFormType::class);
        $contact = $form->handleRequest($request);
        if($form->isSubmitted() && $form->isValid())
        {
            $email = (new TemplatedEmail())
                ->from($contact->get('email')->getData())
                ->to('alkimspsg@gmail.com')
                ->subject('contact au sujet de '.$contact->get('objet')->getData())
                ->htmlTemplate('emails/contact_form.html.twig')
                
                ->context([
                    'object' => $contact->get('objet')->getData(),     
                    'e_mail'=>$contact->get('email')->getData(),
                    'message'=>$contact->get('message')->getData()
                ]);
                
        
        $mailer->send($email);
        $this->addFlash('success', 'votre mail a été envoyé !');
        return $this->redirectToRoute('app_pages_contact');
    }
        return $this->render('pages/contact.html.twig',[
            'form' => $form->createView()
        ]);
    }
}
