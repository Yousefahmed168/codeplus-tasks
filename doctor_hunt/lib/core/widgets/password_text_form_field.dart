import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/style_atoms.dart';
import '../utils/text_styles.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    this.hintText,
    this.controller,
    this.validator,
    this.labelText,
    this.trailing,
    this.prefixIcon,
  });

  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? trailing;
  final Widget? prefixIcon;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: context.regular14),
          const Gap(8),
        ],

        TextFormField(
          controller: widget.controller,
          obscureText: obscureText,
          style: context.regular14.textPrimary,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            ),
            prefixIcon: widget.prefixIcon,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
