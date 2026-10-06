import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/style_atoms.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText,
    this.validator,
    this.prefixIcon,
    this.isExpanded = false,
  });

  final List<T> items;
  final T? value;
  final String? hintText;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: isExpanded,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint, size: 20),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIcon != null
            ? const BoxConstraints(minWidth: 32, minHeight: 32)
            : null,
        contentPadding: prefixIcon != null
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 12)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
      hint: hintText != null
          ? Text(hintText!, style: context.regular14.textSecondary)
          : null,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            item.toString(),
            style: context.semiBold14.textPrimary,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
