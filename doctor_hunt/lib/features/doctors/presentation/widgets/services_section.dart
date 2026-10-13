import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key, required this.services});

  final List<String> services;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.doctorDetails.services, style: context.bold18.textPrimary),
        12.verticalSpace,
        ...List.generate(services.length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i + 1}.', style: context.regular14.textSecondary),
                8.horizontalSpace,
                Expanded(
                  child: Text(services[i], style: context.regular14.textBody),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
