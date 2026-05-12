import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpsurveys/core/constants/app_colors.dart';
import 'package:bpsurveys/core/constants/app_text_styles.dart';
import 'package:bpsurveys/presentation/common/bp_button.dart';

class BPConfirmationDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? doneText;
  final String? cancelText;
  final VoidCallback onDone;
  final VoidCallback? onCancel;
  final VoidCallback? onClose;
  final Color? cancelColor;
  final Color? doneColor;
  final Color? cancelTextColor;
  final Color? doneTextColor;
  final TextDirection buttonDirection;

  const BPConfirmationDialog({
    super.key,
    required this.title,
    required this.onDone,
    this.subtitle = "",
    this.doneText,
    this.cancelText,
    this.onCancel,
    this.onClose,
    this.cancelColor,
    this.doneColor,
    this.cancelTextColor,
    this.doneTextColor,
    this.buttonDirection = TextDirection.ltr,
  });

  static Future<void> show({
    required String title,
    required VoidCallback onDone,
    String subtitle = "",
    String? doneText,
    String? cancelText,
    VoidCallback? onCancel,
    VoidCallback? onClose,
    Color? cancelColor,
    Color? doneColor,
    Color? cancelTextColor,
    Color? doneTextColor,
    TextDirection buttonDirection = TextDirection.ltr,
  }) async {
    return Get.dialog(
      BPConfirmationDialog(
        title: title,
        onDone: onDone,
        subtitle: subtitle,
        doneText: doneText,
        cancelText: cancelText,
        onCancel: onCancel,
        onClose: onClose,
        cancelColor: cancelColor,
        doneColor: doneColor,
        cancelTextColor: cancelTextColor,
        doneTextColor: doneTextColor,
        buttonDirection: buttonDirection,
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(context),
    );
  }

  Widget _contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.grey),
                onPressed: onClose ?? () => Get.back(),
              ),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF334155)),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          Row(
            textDirection: buttonDirection,
            children: [
              Expanded(
                child: BPButton(
                  text: cancelText ?? "Cancel".tr,
                  type: BPButtonType.outline,
                  buttonColor: cancelColor ?? AppColors.grey,
                  onPressed: onCancel ?? () => Get.back(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BPButton(
                  text: doneText ?? "Yes".tr,
                  buttonColor: doneColor ?? AppColors.appMainColor,
                  onPressed: onDone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
