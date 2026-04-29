import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar'); // Default to Arabic

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['ar', 'en', 'fr', 'es'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  void cycleLocale() {
    final Map<String, String> localeCycle = {
      'ar': 'en',
      'en': 'fr',
      'fr': 'es',
      'es': 'ar',
    };
    final nextCode = localeCycle[_locale.languageCode] ?? 'ar';
    setLocale(Locale(nextCode));
  }
}
