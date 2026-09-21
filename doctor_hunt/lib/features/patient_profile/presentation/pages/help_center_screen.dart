import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';

import '../../../../core/widgets/widgets.dart';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: CustomBackButton(),
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
            padding: const EdgeInsets.all(20),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  t.helpCenter.issueHeader,
                  style: context.medium16.copyWith(color: AppColors.primary),
                ),
              ),
              const Gap(16),

              // Issues list
              ...issues.map(
                (issue) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected: $issue'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
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
                                color: const Color(0xFF6B779A),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF6B779A),
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(32),
            ],
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
}
