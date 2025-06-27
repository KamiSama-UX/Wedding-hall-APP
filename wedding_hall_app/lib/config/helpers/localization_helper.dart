
import 'dart:io';
import 'dart:ui';


class LocalizationHelper {
  static String languageCode = Platform.localeName.substring(0, 2);

  static Locale currentLocale() {
    return Locale(languageCode);
  }
}
