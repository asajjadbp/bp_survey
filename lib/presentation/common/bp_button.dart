import 'package:flutter/material.dart';
import 'package:bpsurveys/core/constants/app_colors.dart';
import 'package:bpsurveys/core/constants/app_text_styles.dart';

enum BPButtonType { primary, outline, text }

class BPButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final BPButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final Color? buttonColor;
  final double? fontSize;
  final double? verticalPadding;
  final IconData? icon;

  const BPButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = BPButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.fontSize,
    this.verticalPadding,
    this.icon,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: type == BPButtonType.primary
          ? ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor ?? AppColors.appMainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 16),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: AppTextStyles.button.copyWith(fontSize: fontSize),
                        ),
                      ],
                    ),
            )
          : type == BPButtonType.outline
              ? OutlinedButton(
                  onPressed: isLoading ? null : onPressed,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: buttonColor ?? AppColors.appMainColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: buttonColor ?? AppColors.appMainColor, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: AppTextStyles.button.copyWith(
                          color: buttonColor ?? AppColors.appMainColor,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                )
              : TextButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      color: buttonColor ?? AppColors.appMainColor,
                      fontSize: fontSize,
                    ),
                  ),
                ),
    );
  }
}
