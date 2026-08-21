import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doctor_hunt/core/theme/style_atoms.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.onChange,
    this.textInputAction,
    this.controller,
    this.textAlign = TextAlign.start,
    this.maxLines,
  });
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final Function()? onTap;
  final Function(String)? onChange;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: context.regular14.textPrimary,
      keyboardType: keyboardType,
      readOnly: readOnly,
      focusNode: focusNode,
      maxLines: maxLines,
      textAlign: textAlign,
      textInputAction: textInputAction,
      inputFormatters: [
        if (keyboardType == TextInputType.phone)
          LengthLimitingTextInputFormatter(11),
      ],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onChanged: onChange,
      onTap: onTap,
    );
  }
}
