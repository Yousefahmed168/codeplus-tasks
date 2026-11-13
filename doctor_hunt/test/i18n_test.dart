import 'package:doctor_hunt/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('translations', () {
    test('supports english and arabic', () {
      expect(AppLocaleUtils.supportedLocalesRaw, ['en', 'ar']);
    });

    test('arabic strings are available', () async {
      // Arabic is a deferred slang library, so it must be loaded asynchronously.
      final ar = await AppLocale.ar.build();

      expect(ar.home.popularDoctor, 'أشهر الأطباء');
      expect(ar.home.greeting(name: 'يوسف'), 'أهلًا، يوسف 👋');
      expect(ar.common.language, 'اللغة');
      // @name placeholders must survive the translation.
      expect(ar.admin.doctors.deleteConfirm, contains('@name'));
    });

    test('english strings are available', () {
      final en = AppLocale.en.buildSync();

      expect(en.common.language, 'Language');
      expect(en.home.bookNow, 'Book Now');
    });

    test('raw locale parsing resolves to the matching enum', () {
      expect(AppLocaleUtils.parse('ar'), AppLocale.ar);
      expect(AppLocaleUtils.parse('en'), AppLocale.en);
    });
  });
}
