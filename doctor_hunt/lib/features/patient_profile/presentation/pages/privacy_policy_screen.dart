import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: CustomBackButton(),
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
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: 40,
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
                const Gap(16),
                Text(
                  'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words believable. It is a long established fact that reader will distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here\', making it look like readable English.',
                  style: context.regular14.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const Gap(20),
                _buildBulletPoint(
                  context,
                  'The standard chunk of Lorem Ipsum used since 1500s is reproduced below for those interested.',
                ),
                const Gap(14),
                _buildBulletPoint(
                  context,
                  'Sections 110.32 and 110.33 from "de Finibus Bonorum et Malorum". The point of using.',
                ),
                const Gap(14),
                _buildBulletPoint(
                  context,
                  'Lorem Ipsum is that it has a more-or-less normal distribution of letters.',
                ),
                const Gap(14),
                _buildBulletPoint(
                  context,
                  'The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.',
                ),
                const Gap(24),
                Text(
                  'It is a long established fact that reader distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.',
                  style: context.regular14.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const Gap(40),
              ],
            ),
          ),
          // Subtle bottom teal gradient decorative flare matching 
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0.0),
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
          margin: const EdgeInsets.only(top: 6),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const Gap(12),
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
