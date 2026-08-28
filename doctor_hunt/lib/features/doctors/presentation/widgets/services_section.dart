import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key, required this.services});

  final List<String> services;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.doctorDetails.services, style: context.bold18.textPrimary),
        Gap(12),
        ...List.generate(services.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i + 1}.', style: context.regular14.textSecondary),
                Gap(8),
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
