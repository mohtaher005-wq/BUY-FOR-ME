// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Buy For Me';

  @override
  String get welcomeMessage => 'Welcome to the smart shopping app';

  @override
  String get emailLabel => 'Email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get signUpButton => 'Create new account';

  @override
  String get emailPasswordRequired => 'Please enter your email and password';

  @override
  String get signUpSuccess =>
      'Account created successfully! You can now login.';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get errorPrefix => 'Error:';

  @override
  String get roleSelectionTitle => 'Welcome to\nBUY FOR ME';

  @override
  String get roleSelectionSubtitle =>
      'Choose your identity to start shopping or selling';

  @override
  String get customerRole => 'I\'m a Customer';

  @override
  String get customerRoleDesc =>
      'I\'m looking for stores and want to buy products';

  @override
  String get merchantRole => 'I\'m a Merchant';

  @override
  String get merchantRoleDesc => 'I have a store and want to sell products';

  @override
  String get merchantSetupTitle => 'Setup Store';

  @override
  String get merchantSetupGreeting =>
      'Welcome, Merchant!\nLet\'s set up your store to start receiving orders.';

  @override
  String get storeImage => 'Store Image';

  @override
  String get takePhoto => 'Take a photo of your store';

  @override
  String get storeName => 'Store Name';

  @override
  String get storeNameHint => 'Enter your store name here...';

  @override
  String get ripLabel => 'RIP Account Number';

  @override
  String get ripHint => 'Example: 00799999000123456789';

  @override
  String get categoryLabel => 'Identify your commerce category';

  @override
  String get categoryHint => 'Choose main activity...';

  @override
  String get nextButton => 'Next';

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get productsTab => 'Products';

  @override
  String get ordersTab => 'Orders';

  @override
  String get searchHint => 'Search for nearby stores...';

  @override
  String get nearbyStores => 'Available stores nearby';

  @override
  String distanceKm(String distance) {
    return '$distance km';
  }

  @override
  String confirmOrder(String count) {
    return 'Confirm Order ($count)';
  }

  @override
  String get addToCart => 'Add';

  @override
  String get rateStore => 'Rate store now:';

  @override
  String get submitRating => 'Submit Rating';

  @override
  String get ratingPrompt => 'What is your rating for this store?';

  @override
  String get waitingStatus => 'Waiting';

  @override
  String get deliveryType => 'Delivery';

  @override
  String get pickupType => 'Pickup';

  @override
  String get catGrocery => 'General Groceries';

  @override
  String get catFruitVeg => 'Fruits & Vegetables';

  @override
  String get catBakery => 'Bakery';

  @override
  String get catButchery => 'Butchery';

  @override
  String get catCleaning => 'Cleaning Products';

  @override
  String get catOther => 'Other';

  @override
  String get pickFromCamera => 'Take a photo with camera';

  @override
  String get pickFromGallery => 'Choose from gallery';

  @override
  String get deletePhoto => 'Delete photo';

  @override
  String get noStoresNearby => 'No stores nearby at the moment';

  @override
  String get viewAll => 'All';

  @override
  String get ratingSuccess => 'تم إرسال التقييم بنجاح! شكرًا لك.';

  @override
  String get signInButton => 'Sign In';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get jobSeekerRole => 'Search for Work';

  @override
  String get jobSeekerRoleDesc =>
      'Looking for work opportunities in available stores';

  @override
  String get storeLocationOnMap => 'Store location on map';
}
