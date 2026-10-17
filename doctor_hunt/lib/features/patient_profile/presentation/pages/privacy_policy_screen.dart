import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          t.privacyPolicy.title,
          style: context.bold18.textPrimary,
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 16.h,
              bottom: 40.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.privacyPolicy.heading,
                  style: context.bold18.copyWith(
                    color: AppColors.policyBackground,
                  ),
                ),
                16.verticalSpace,
                Text(
                  t.privacyPolicy.intro,
                  style: context.regular14.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                20.verticalSpace,
                _buildBulletPoint(context, t.privacyPolicy.bullet1),
                14.verticalSpace,
                _buildBulletPoint(context, t.privacyPolicy.bullet2),
                14.verticalSpace,
                _buildBulletPoint(context, t.privacyPolicy.bullet3),
                14.verticalSpace,
                _buildBulletPoint(context, t.privacyPolicy.bullet4),
                24.verticalSpace,
                Text(
                  t.privacyPolicy.outro,
                  style: context.regular14.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                40.verticalSpace,
              ],
            ),
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

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h),
          width: 8.r,
          height: 8.r,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: context.regular14.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
