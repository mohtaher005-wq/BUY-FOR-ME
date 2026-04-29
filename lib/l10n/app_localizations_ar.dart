// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'اشترِ لي';

  @override
  String get welcomeMessage => 'مرحباً بك في تطبيق التسوق الذكي';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get signUpButton => 'إنشاء حساب جديد';

  @override
  String get emailPasswordRequired =>
      'الرجاء إدخال البريد الإلكتروني وكلمة المرور';

  @override
  String get signUpSuccess => 'تم إنشاء الحساب بنجاح! يمكنك الآن تسجيل الدخول.';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get errorPrefix => 'خطأ:';

  @override
  String get roleSelectionTitle => 'أهلاً بك في\nBUY FOR ME';

  @override
  String get roleSelectionSubtitle => 'اختر هويتك للبدء بالتسوق أو البيع';

  @override
  String get customerRole => 'أنا زبون';

  @override
  String get customerRoleDesc => 'أبحث عن متاجر وأريد شراء منتجات';

  @override
  String get merchantRole => 'أنا تاجر';

  @override
  String get merchantRoleDesc => 'لدي محل وأريد عرض بضاعتي للناس';

  @override
  String get merchantSetupTitle => 'إعداد المتجر';

  @override
  String get merchantSetupGreeting =>
      'أهلاً بك أيها التاجر!\nلنقم بإعداد متجرك للبدء باستقبال الطلبات.';

  @override
  String get storeImage => 'صورة المتجر من الخارج';

  @override
  String get takePhoto => 'التقط صورة لمتجرك';

  @override
  String get storeName => 'اسم المتجر';

  @override
  String get storeNameHint => 'أدخل اسم متجرك هنا...';

  @override
  String get ripLabel => 'رقم الحساب الجاري (RIP) لبريدي موب';

  @override
  String get ripHint => 'مثال: 00799999000123456789';

  @override
  String get categoryLabel => 'تحديد صنف ما تبيع من بضاعة';

  @override
  String get categoryHint => 'اختر النشاط الرئيسي...';

  @override
  String get nextButton => 'التالي';

  @override
  String get fillAllFields => 'يرجى إكمال جميع الحقول';

  @override
  String get productsTab => 'المنتجات';

  @override
  String get ordersTab => 'الطلبات';

  @override
  String get searchHint => 'ابحث عن المتاجر القريبة منك...';

  @override
  String get nearbyStores => 'المتاجر المتاحة حولك';

  @override
  String distanceKm(String distance) {
    return '$distance كم';
  }

  @override
  String confirmOrder(String count) {
    return 'تأكيد الطلب ($count)';
  }

  @override
  String get addToCart => 'أضف';

  @override
  String get rateStore => 'قيّم المتجر الآن:';

  @override
  String get submitRating => 'إرسال التقييم';

  @override
  String get ratingPrompt => 'ما هو تقييمك لهذا المتجر؟';

  @override
  String get waitingStatus => 'قيد الانتظار';

  @override
  String get deliveryType => 'توصيل';

  @override
  String get pickupType => 'استلام';

  @override
  String get catGrocery => 'مواد غذائية عامة';

  @override
  String get catFruitVeg => 'خضر وفواكه';

  @override
  String get catBakery => 'مخبزة ومعجنات';

  @override
  String get catButchery => 'قصابة ولحوم';

  @override
  String get catCleaning => 'مواد تنظيف';

  @override
  String get catOther => 'أخرى';

  @override
  String get pickFromCamera => 'التقط صورة بالكاميرا';

  @override
  String get pickFromGallery => 'اختر من معرض الصور';

  @override
  String get deletePhoto => 'حذف الصورة';

  @override
  String get noStoresNearby => 'لا توجد متاجر قريبة حالياً';

  @override
  String get viewAll => 'الكل';

  @override
  String get ratingSuccess => 'تم إرسال التقييم بنجاح! شكرًا لك.';

  @override
  String get signInButton => 'تسجيل دخول';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get jobSeekerRole => 'ابحث عن عمل';

  @override
  String get jobSeekerRoleDesc => 'أبحث عن فرص عمل في المتاجر المتاحة';

  @override
  String get storeLocationOnMap => 'موقع المتجر على الخريطة';
}
