import 'dart:ui';

import 'package:get/get.dart';

import '../session/preference.dart';
import 'language/en_us.dart';

class AppTranslation extends Translations {
  // Default locale
  static const locale = Locale('en', 'US');

  static Locale getLocal() {
    if (Preference.getLanguage() == "French") {
      return const Locale('fr', 'FR');
    }
    return const Locale('en', 'US');
  }

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('en', 'US');

  // Supported languages
  // Needs to be same order with locales
  static const language = [
    'EN',
    'FR',
  ];

  // Supported locales
  // Needs to be same order with langs
  static const locales = [
    Locale('en', 'US'),
    Locale('fr', 'FR'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        // Add another language files
        'en_US': enUS, // lang/tr_tr.dart
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale!);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale? _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < language.length; i++) {
      if (lang == language[i]) {
        Preference.setLanguage(lang);
        return locales[i];
      }
    }
    return Get.locale;
  }
}
