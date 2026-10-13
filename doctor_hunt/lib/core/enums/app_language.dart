/// Languages the app can be displayed in.
///
/// Only [english] ships today. slang falls back to the base locale when a
/// translation is missing, so adding a language means adding a value here plus
/// a `strings_<code>.i18n.json` file, then applying it through
/// `LocaleSettings.setLocale`.
enum AppLanguage {
  english('en');

  const AppLanguage(this.code);

  /// ISO 639-1 code, matching the slang locale code.
  final String code;

  /// Resolves a stored code back to an [AppLanguage], defaulting to English.
  static AppLanguage fromCode(String? code) {
    for (final language in AppLanguage.values) {
      if (language.code == code) return language;
    }
    return AppLanguage.english;
  }
}
