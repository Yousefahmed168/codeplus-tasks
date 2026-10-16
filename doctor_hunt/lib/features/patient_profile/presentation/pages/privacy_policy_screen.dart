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
                  'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words believable. It is a long established fact that reader will distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here\', making it look like readable English.',
                  style: context.regular14.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                20.verticalSpace,
                _buildBulletPoint(
                  context,
                  'The standard chunk of Lorem Ipsum used since 1500s is reproduced below for those interested.',
                ),
                14.verticalSpace,
                _buildBulletPoint(
                  context,
                  'Sections 110.32 and 110.33 from "de Finibus Bonorum et Malorum". The point of using.',
                ),
                14.verticalSpace,
                _buildBulletPoint(
                  context,
                  'Lorem Ipsum is that it has a more-or-less normal distribution of letters.',
                ),
                14.verticalSpace,
                _buildBulletPoint(
                  context,
                  'The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.',
                ),
                24.verticalSpace,
                Text(
                  'It is a long established fact that reader distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.',
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
