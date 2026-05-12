import 'package:flutter/material.dart';
import 'package:bpsurveys/core/constants/app_colors.dart';
import 'package:bpsurveys/core/constants/app_text_styles.dart';

class BPInputField extends StatelessWidget {
  final String hintText;
  final String? label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final bool isReadOnly;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool isRequired;

  const BPInputField({
    super.key,
    required this.hintText,
    this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.isReadOnly = false,
    this.validator,
    this.autovalidateMode,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      readOnly: isReadOnly,
      validator: validator,
      autovalidateMode: autovalidateMode,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        label: isRequired 
          ? Text.rich(
              TextSpan(
                text: label ?? hintText,
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.error),
                  ),
                ],
              ),
            )
          : null,
        labelText: isRequired ? null : (label ?? hintText),
        hintText: label != null ? hintText : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey,
          fontWeight: FontWeight.normal,
        ),
        floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.appMainColor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.appMainColor,
            width: 1.5,
          ),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 22, color: AppColors.appMainColor)
            : null,
        suffixIcon: suffixIcon,
        hintStyle: AppTextStyles.caption.copyWith(color: AppColors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        isDense: true,
      ),
    );
  }
}
