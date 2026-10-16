import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/enums/app_language.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/constants/my_icons.dart';

/// Bottom sheet that lists the languages the app can be displayed in.
///
/// Pops with the chosen [AppLanguage], or `null` when dismissed.
class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({super.key, required this.selected});

  final AppLanguage selected;

  static Future<AppLanguage?> show(
    BuildContext context, {
    required AppLanguage selected,
  }) {
    return showModalBottomSheet<AppLanguage>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => LanguagePickerSheet(selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.verticalSpace,
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              t.patientSettings.selectLanguage,
              style: context.bold16.textPrimary,
            ),
          ),
          8.verticalSpace,
          for (final language in AppLanguage.values)
            ListTile(
              onTap: () => Navigator.of(context).pop(language),
              title: Text(_labelFor(language), style: context.medium14.textPrimary),
              trailing: language == selected
                  ? Icon(
                      MyIcons.checkCircleRounded,
                      color: AppColors.primary,
                      size: 22.r,
                    )
                  : null,
            ),
          12.verticalSpace,
        ],
      ),
    );
  }

  /// Display name of [language]; every supported locale needs an entry here.
  String _labelFor(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return t.patientSettings.languageEnglish;
    }
  }
}
