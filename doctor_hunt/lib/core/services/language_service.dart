import '../../i18n/strings.g.dart';
import 'local/shared_pref.dart';

/// Applies and persists the app language picked by the user.
class LanguageService {
  LanguageService._();

  static final LanguageService instance = LanguageService._();

  /// The language picked inside the app, or null when it still follows the
  /// device locale.
  AppLocale? get savedLanguage {
    if (!SharedPref.isInitialized) return null;
    final code = SharedPref.pref.getString(SharedPref.kLanguage);
    if (code == null || code.isEmpty) return null;
    try {
      return AppLocaleUtils.parse(code);
    } catch (_) {
      return null;
    }
  }

  /// Applies [locale] (localized widgets rebuild immediately) and persists it.
  Future<void> setLanguage(AppLocale locale) async {
    await LocaleSettings.setLocale(locale, listenToDeviceLocale: false);
    await SharedPref.cacheLanguage(locale.languageCode);
  }
}
