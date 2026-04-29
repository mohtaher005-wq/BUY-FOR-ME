import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'اشترِ لي'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في تطبيق التسوق الذكي'**
  String get welcomeMessage;

  /// No description provided for @emailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginButton;

  /// No description provided for @signUpButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get signUpButton;

  /// No description provided for @emailPasswordRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال البريد الإلكتروني وكلمة المرور'**
  String get emailPasswordRequired;

  /// No description provided for @signUpSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب بنجاح! يمكنك الآن تسجيل الدخول.'**
  String get signUpSuccess;

  /// No description provided for @unexpectedError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع'**
  String get unexpectedError;

  /// No description provided for @errorPrefix.
  ///
  /// In ar, this message translates to:
  /// **'خطأ:'**
  String get errorPrefix;

  /// No description provided for @roleSelectionTitle.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك في\nBUY FOR ME'**
  String get roleSelectionTitle;

  /// No description provided for @roleSelectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر هويتك للبدء بالتسوق أو البيع'**
  String get roleSelectionSubtitle;

  /// No description provided for @customerRole.
  ///
  /// In ar, this message translates to:
  /// **'أنا زبون'**
  String get customerRole;

  /// No description provided for @customerRoleDesc.
  ///
  /// In ar, this message translates to:
  /// **'أبحث عن متاجر وأريد شراء منتجات'**
  String get customerRoleDesc;

  /// No description provided for @merchantRole.
  ///
  /// In ar, this message translates to:
  /// **'أنا تاجر'**
  String get merchantRole;

  /// No description provided for @merchantRoleDesc.
  ///
  /// In ar, this message translates to:
  /// **'لدي محل وأريد عرض بضاعتي للناس'**
  String get merchantRoleDesc;

  /// No description provided for @merchantSetupTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعداد المتجر'**
  String get merchantSetupTitle;

  /// No description provided for @merchantSetupGreeting.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك أيها التاجر!\nلنقم بإعداد متجرك للبدء باستقبال الطلبات.'**
  String get merchantSetupGreeting;

  /// No description provided for @storeImage.
  ///
  /// In ar, this message translates to:
  /// **'صورة المتجر من الخارج'**
  String get storeImage;

  /// No description provided for @takePhoto.
  ///
  /// In ar, this message translates to:
  /// **'التقط صورة لمتجرك'**
  String get takePhoto;

  /// No description provided for @storeName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المتجر'**
  String get storeName;

  /// No description provided for @storeNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم متجرك هنا...'**
  String get storeNameHint;

  /// No description provided for @ripLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الحساب الجاري (RIP) لبريدي موب'**
  String get ripLabel;

  /// No description provided for @ripHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: 00799999000123456789'**
  String get ripHint;

  /// No description provided for @categoryLabel.
  ///
  /// In ar, this message translates to:
  /// **'تحديد صنف ما تبيع من بضاعة'**
  String get categoryLabel;

  /// No description provided for @categoryHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر النشاط الرئيسي...'**
  String get categoryHint;

  /// No description provided for @nextButton.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get nextButton;

  /// No description provided for @fillAllFields.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إكمال جميع الحقول'**
  String get fillAllFields;

  /// No description provided for @productsTab.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get productsTab;

  /// No description provided for @ordersTab.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات'**
  String get ordersTab;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن المتاجر القريبة منك...'**
  String get searchHint;

  /// No description provided for @nearbyStores.
  ///
  /// In ar, this message translates to:
  /// **'المتاجر المتاحة حولك'**
  String get nearbyStores;

  /// No description provided for @distanceKm.
  ///
  /// In ar, this message translates to:
  /// **'{distance} كم'**
  String distanceKm(String distance);

  /// No description provided for @confirmOrder.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب ({count})'**
  String confirmOrder(String count);

  /// No description provided for @addToCart.
  ///
  /// In ar, this message translates to:
  /// **'أضف'**
  String get addToCart;

  /// No description provided for @rateStore.
  ///
  /// In ar, this message translates to:
  /// **'قيّم المتجر الآن:'**
  String get rateStore;

  /// No description provided for @submitRating.
  ///
  /// In ar, this message translates to:
  /// **'إرسال التقييم'**
  String get submitRating;

  /// No description provided for @ratingPrompt.
  ///
  /// In ar, this message translates to:
  /// **'ما هو تقييمك لهذا المتجر؟'**
  String get ratingPrompt;

  /// No description provided for @waitingStatus.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار'**
  String get waitingStatus;

  /// No description provided for @deliveryType.
  ///
  /// In ar, this message translates to:
  /// **'توصيل'**
  String get deliveryType;

  /// No description provided for @pickupType.
  ///
  /// In ar, this message translates to:
  /// **'استلام'**
  String get pickupType;

  /// No description provided for @catGrocery.
  ///
  /// In ar, this message translates to:
  /// **'مواد غذائية عامة'**
  String get catGrocery;

  /// No description provided for @catFruitVeg.
  ///
  /// In ar, this message translates to:
  /// **'خضر وفواكه'**
  String get catFruitVeg;

  /// No description provided for @catBakery.
  ///
  /// In ar, this message translates to:
  /// **'مخبزة ومعجنات'**
  String get catBakery;

  /// No description provided for @catButchery.
  ///
  /// In ar, this message translates to:
  /// **'قصابة ولحوم'**
  String get catButchery;

  /// No description provided for @catCleaning.
  ///
  /// In ar, this message translates to:
  /// **'مواد تنظيف'**
  String get catCleaning;

  /// No description provided for @catOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get catOther;

  /// No description provided for @pickFromCamera.
  ///
  /// In ar, this message translates to:
  /// **'التقط صورة بالكاميرا'**
  String get pickFromCamera;

  /// No description provided for @pickFromGallery.
  ///
  /// In ar, this message translates to:
  /// **'اختر من معرض الصور'**
  String get pickFromGallery;

  /// No description provided for @deletePhoto.
  ///
  /// In ar, this message translates to:
  /// **'حذف الصورة'**
  String get deletePhoto;

  /// No description provided for @noStoresNearby.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد متاجر قريبة حالياً'**
  String get noStoresNearby;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get viewAll;

  /// No description provided for @ratingSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال التقييم بنجاح! شكرًا لك.'**
  String get ratingSuccess;

  /// No description provided for @signInButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دخول'**
  String get signInButton;

  /// No description provided for @noAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get noAccount;

  /// No description provided for @jobSeekerRole.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن عمل'**
  String get jobSeekerRole;

  /// No description provided for @jobSeekerRoleDesc.
  ///
  /// In ar, this message translates to:
  /// **'أبحث عن فرص عمل في المتاجر المتاحة'**
  String get jobSeekerRoleDesc;

  /// No description provided for @storeLocationOnMap.
  ///
  /// In ar, this message translates to:
  /// **'موقع المتجر على الخريطة'**
  String get storeLocationOnMap;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
