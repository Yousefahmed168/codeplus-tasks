import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../i18n/strings.g.dart';
import '../constants/my_icons.dart';
import '../di/service_locator.dart';
import '../services/language_service.dart';
import '../theme/colors.dart';
import '../theme/style_atoms.dart';
import '../utils/snack_bar_helper.dart';

/// Lets the user switch between the app locales.
///
/// The choice is persisted by [LanguageService]; localized widgets rebuild
/// immediately because [TranslationProvider] reacts to the locale change.
class LanguagePickerDialog {
  LanguagePickerDialog._();

  /// Display name of the currently active locale in its own wording.
  static String currentLabel() => labelOf(LocaleSettings.currentLocale);

  static String labelOf(AppLocale locale) => switch (locale) {
    AppLocale.en => t.common.languageEnglish,
    AppLocale.ar => t.common.languageArabic,
  };

  static Future<void> show(BuildContext context) async {
    final selected = await showDialog<AppLocale>(
      context: context,
      builder: (dialogContext) {
        final current = LocaleSettings.currentLocale;
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(t.common.language, style: context.bold16.textPrimary),
          children: [
            for (final locale in AppLocale.values)
              SimpleDialogOption(
                onPressed: () => Navigator.of(dialogContext).pop(locale),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        labelOf(locale),
                        style: context.medium14.textPrimary,
                      ),
                    ),
                    if (locale == current)
                      Icon(MyIcons.check, color: AppColors.primary, size: 22.r),
                  ],
                ),
              ),
          ],
        );
      },
    );

    if (selected == null) return;
    await sl<LanguageService>().setLanguage(selected);
    if (!context.mounted) return;
    SnackBarHelper.show(context, t.common.languageUpdated);
  }
}
