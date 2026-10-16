import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/constants/my_icons.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final issues = [
      'Booking a new Appointment',
      'Existing Appointment',
      'Online consultations',
      'Feedbacks',
      'Medicine orders',
      'Diagnostic Tests',
      'Health plans',
      'My account and Practo Drive',
      'Have a feature in mind',
      'Other issues',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const CustomBackButton(),
        ),
        title: Text(
          t.helpCenter.title,
          style: context.bold18.textPrimary,
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20.r),
            children: [
              // Header Card
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.03),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Text(
                  t.helpCenter.issueHeader,
                  style: context.medium16.copyWith(color: AppColors.primary),
                ),
              ),
              16.verticalSpace,

              // Issues list
              ...issues.map(
                (issue) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: InkWell(
                    onTap: () {
                      SnackBarHelper.show(
                        context,
                        t.helpCenter.selectedIssue(issue: issue),
                        color: AppColors.primary,
                      );
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withValues(alpha: 0.02),
                            blurRadius: 6.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              issue,
                              style: context.regular14.copyWith(
                                color: AppColors.helpText,
                              ),
                            ),
                          ),
                          Icon(
                            MyIcons.chevronRightRounded,
                            color: AppColors.helpText,
                            size: 22.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              32.verticalSpace,
            ],
          ),
          // Subtle bottom teal gradient decorative flare matching 
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100.h,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      AppColors.surface.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
