##Application E-Commerce - Flutter avec Firebase
Cette application Flutter est une solution complète de commerce électronique intégrée à Firebase, permettant la gestion des produits, des utilisateurs et des paniers d'achat. Elle propose une interface intuitive et fluide avec plusieurs fonctionnalités modernes adaptées au commerce en ligne.

##Fonctionnalités

1.Gestion des Produits
Affichage des produits : Consultation d'une liste d'articles avec images, tailles, prix et détails.
Ajout de produits : Fonctionnalité pour ajouter de nouveaux vêtements à la base de données via un formulaire.
Détails des produits : Affichage d'informations détaillées sur chaque produit.

2.Panier
Ajouter ou supprimer au panier : Possibilité d'ajouter des articles dans un panier personnalisé.
Gestion des quantités : Mise à jour des quantités pour chaque article sélectionné.


3.Profil Utilisateur
Gestion du profil : Consultation et mise à jour des informations personnelles de l'utilisateur connecté.

4.Authentification
Connexion et inscription : Utilisation de Firebase Authentication pour sécuriser les comptes utilisateur.

##Interactivité
1.Navigation
Barre de navigation : Accès rapide aux sections "Acheter", "Panier", "Profil" et "Ajouter un produit".
Transitions fluides : Navigation intuitive entre les écrans grâce à Flutter Navigator.

2.Gestion des états
Provider : Gestion centralisée des états avec Provider pour une meilleure performance et simplicité.

##Comptes Utilisateurs de Test
login: elbir.youssef22@gmail.com / password: 123456

##Améliorations Futures

Interaction intelligente avec un chatbot : Implémentation d'un chatbot basé sur Dialogflow pour répondre automatiquement aux questions des utilisateurs concernant les tailles, la livraison et les retours.
Un exemple de code pour cette intégration est déjà inclus dans le projet (chat_screen.dart et dialogflow_service.dart), mais il nécessite des ajustements pour fonctionner correctement.
Le chatbot utilise des modèles de traitement du langage naturel (NLP) pour des réponses plus adaptées.

##Problèmes Connus

1.Chatbot non fonctionnel : Bien que l'intégration de Dialogflow soit en place, des problèmes empêchent actuellement son fonctionnement. Une correction est en cours pour assurer la communication avec l'API Dialogflow et afficher les réponses dans l'application.

2.Problème de connexion : Lors de la première connexion, il est nécessaire de cliquer sur le bouton Login, après quoi une erreur est affichée. Il faut ensuite saisir à nouveau le login et le mot de passe, et l'authentification fonctionne correctement. Le problème survient car l'interface se bloque si ces informations sont ajoutées dès le départ.

