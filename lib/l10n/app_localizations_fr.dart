// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Achète Pour Moi';

  @override
  String get welcomeMessage =>
      'Bienvenue sur l\'application de shopping intelligent';

  @override
  String get emailLabel => 'Adresse e-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get signUpButton => 'Créer un nouveau compte';

  @override
  String get emailPasswordRequired =>
      'Veuillez entrer votre adresse e-mail et votre mot de passe';

  @override
  String get signUpSuccess =>
      'Compte créé avec succès ! Vous pouvez maintenant vous connecter.';

  @override
  String get unexpectedError => 'Une erreur inattendue s\'est produite';

  @override
  String get errorPrefix => 'Erreur:';

  @override
  String get roleSelectionTitle => 'Bienvenue sur\nBUY FOR ME';

  @override
  String get roleSelectionSubtitle =>
      'Choisissez votre identité pour commencer';

  @override
  String get customerRole => 'Je suis Client';

  @override
  String get customerRoleDesc => 'Je cherche des magasins et des produits';

  @override
  String get merchantRole => 'Je suis Commerçant';

  @override
  String get merchantRoleDesc => 'J\'ai un magasin et je vends des produits';

  @override
  String get merchantSetupTitle => 'Configuration';

  @override
  String get merchantSetupGreeting =>
      'Bienvenue, Commerçant!\nConfigurons votre magasin pour recevoir des commandes.';

  @override
  String get storeImage => 'Image du magasin';

  @override
  String get takePhoto => 'Prenez une photo de votre magasin';

  @override
  String get storeName => 'Nom du magasin';

  @override
  String get storeNameHint => 'Entrez le nom de votre magasin...';

  @override
  String get ripLabel => 'Numéro de compte RIP';

  @override
  String get ripHint => 'Ex: 00799999000123456789';

  @override
  String get categoryLabel => 'Identifiez votre catégorie de commerce';

  @override
  String get categoryHint => 'Choisissez l\'activité...';

  @override
  String get nextButton => 'Suivant';

  @override
  String get fillAllFields => 'Veuillez remplir tous les champs';

  @override
  String get productsTab => 'Produits';

  @override
  String get ordersTab => 'Commandes';

  @override
  String get searchHint => 'Rechercher des magasins à proximité...';

  @override
  String get nearbyStores => 'Magasins disponibles à proximité';

  @override
  String distanceKm(String distance) {
    return '$distance km';
  }

  @override
  String confirmOrder(String count) {
    return 'Confirmer Commande ($count)';
  }

  @override
  String get addToCart => 'Ajouter';

  @override
  String get rateStore => 'Noter le magasin:';

  @override
  String get submitRating => 'Envoyer la Note';

  @override
  String get ratingPrompt => 'Quelle est votre note?';

  @override
  String get waitingStatus => 'En attente';

  @override
  String get deliveryType => 'Livraison';

  @override
  String get pickupType => 'Récupération';

  @override
  String get catGrocery => 'Épicerie générale';

  @override
  String get catFruitVeg => 'Fruits & Légumes';

  @override
  String get catBakery => 'Boulangerie';

  @override
  String get catButchery => 'Boucherie';

  @override
  String get catCleaning => 'Produits ménagers';

  @override
  String get catOther => 'Autre';

  @override
  String get pickFromCamera => 'Prendre une photo avec l\'appareil';

  @override
  String get pickFromGallery => 'Choisir dans la galerie';

  @override
  String get deletePhoto => 'Supprimer la photo';

  @override
  String get noStoresNearby => 'Aucun magasin à proximité pour le moment';

  @override
  String get viewAll => 'Tous';

  @override
  String get ratingSuccess => 'تم إرسال التقييم بنجاح! شكرًا لك.';

  @override
  String get signInButton => 'Se connecter';

  @override
  String get noAccount => 'Vous n\'avez pas de compte?';

  @override
  String get jobSeekerRole => 'Rechercher un Emploi';

  @override
  String get jobSeekerRoleDesc =>
      'À la recherche d\'opportunités de travail dans les magasins disponibles';

  @override
  String get storeLocationOnMap => 'موقع المتجر على الخريطة';
}
