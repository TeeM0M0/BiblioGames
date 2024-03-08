# BiblioGames

BiblioGames est une application codée en Flutter dans le cadre de mes études en BTS SIO option SLAM.
Cette application permet d'avoir sa collection de jeux sauvegardés dans son téléphone, avec la possibilité de créer des bibliothèques de jeux et de voir les informations des jeux.

Cette application est le préquel d'un plus gros projet personnel.

## Fonctionnement

L'application démarre sur un splash Screen de 3 s, on est ensuite redirigé sur la page d'accueil sur laquelle se trouvent les différents jeux et boutons pour accéder aux informations des jeux. 
Et un menu déroulant  qui amène soit à la page d'accueil ou sur la page des bibliothèques.

![partie1](partie1.png)

### Page gameInfo :

Sur la page gameInfo, vous avez accès à certaines informations du jeu avec une image de celui-ci. Il y a aussi la possibilité d'ajouter le jeu à une bibliothèque grâce au bouton en bas à droite de la page.

![stat](info.png)

### Page MesBibliothèques :

Sur la page MesBibliothèques l'utilisateur a accès à toutes ces bibliothèques et aux jeux qu'il a ajoutés. Il est possible de supprimer un jeu d'une bibliothèque et toutes les données des bibliothèques sont stockées en local.

![perso](biblio.png)

## Les fichiers

### games.dart 

Games est une classe qui sert à récupérer les données de base des jeux après l'appel de l'API pour afficher la page d'accueil.
Elle possède 3 attributs privés _id , _nom et _img.

### gameInfo.dart 

Games est une classe qui sert à récupérer les données plus précises d'un jeu après l'appel de l'API
Elle possède 8 attributs privés  _nom , _img , _description, _realease, _metacreitic , _platforme , _dev, _dev, _genre.

### bibliothèque/collection/dbetagere/jeu.dart 

Ces classes sont les classes qui permettent la sauvegarde des bibliothèques de manière locale à l'aide de SQLite

### load-gameinfo/load-games.dart 

Ce sont les fichiers qui contiennent les fonctions qui réalisent les appels d'API
