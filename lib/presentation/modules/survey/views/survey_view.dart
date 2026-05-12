import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bpsurveys/core/constants/app_colors.dart';
import 'package:bpsurveys/core/constants/app_text_styles.dart';
import 'package:bpsurveys/presentation/common/bp_app_bar.dart';
import 'package:bpsurveys/presentation/common/bp_button.dart';
import 'package:bpsurveys/presentation/common/bp_confirmation_dialog.dart';
import 'package:bpsurveys/data/models/response_models/survey_questions_response_model.dart';
import '../controllers/survey_controller.dart';

class SurveyView extends GetView<SurveyController> {
  const SurveyView({super.key});

  void _showExitConfirmation() {
    BPConfirmationDialog.show(
      title: "Exit Survey".tr,
      subtitle: "Are you sure you want to exit? Your progress will be lost.".tr,
      buttonDirection: Get.locale == Locale('en') ? TextDirection.rtl : TextDirection.ltr,
      doneColor: Colors.red,
      cancelColor: AppColors.appMainColor,
      cancelText: "No".tr,
      onDone: () {
        Get.back();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAr = controller.getLanguage() == 'ar';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitConfirmation();
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Column(
            children: [
              BPAppBar(
                title: "APSCO Survey".tr,
                onBackTap: _showExitConfirmation,
              ),
              Obx(() {
                if (controller.isLoading.value || controller.allQuestions.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${controller.completedQuestions} / ${controller.totalQuestions}",
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.appMainColor,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            "${(controller.progress * 100).toInt()}%",
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.appMainColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: SizedBox(
                          height: 4,
                          child: LinearProgressIndicator(
                            value: controller.progress,
                            backgroundColor: AppColors.appMainColor.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.appMainColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.allQuestions.isEmpty) {
                    return Center(child: Text("No questions available".tr));
                  }

                  final index = controller.currentIndex.value;
                  final question = controller.allQuestions[index];
                  final category = controller.getCategoryForCurrent();

                  return SingleChildScrollView(
                    key: ValueKey("wizard_step_$index"),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (category != null) _buildCategoryHeader(category, isAr),
                        _buildQuestionCard(question, index, isAr),
                      ],
                    ),
                  );
                }),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(SurveyCategory category, bool isAr) {
    String text = isAr ? category.arAccessType.trim() : category.enAccessType.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.appMainColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index, bool isAr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isAr ? question.arQuestion : question.enQuestion,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (question.answerType.toLowerCase() == 'text')
            _buildTextField(index)
          else if (question.answerType.toLowerCase() == 'numeric')
            _buildNumericField(index)
          else if (question.answerType.toLowerCase() == 'radio')
            _buildRadioOptions(question, index, isAr)
          else if (question.answerType.toLowerCase() == 'checkbox')
            _buildCheckboxOptions(question, index, isAr),
        ],
      ),
    );
  }

  Widget _buildTextField(int index) {
    return TextField(
      key: ValueKey("q_text_$index"),
      controller: controller.getQuestionController(index),
      onChanged: (val) => controller.onTextChanged(index, val),
      decoration: InputDecoration(
        hintText: "Enter your answer".tr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildNumericField(int index) {
    return TextField(
      key: ValueKey("q_num_$index"),
      controller: controller.getQuestionController(index),
      onChanged: (val) => controller.onTextChanged(index, val),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        LengthLimitingTextInputFormatter(5),
      ],
      decoration: InputDecoration(
        hintText: "Enter numeric value".tr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildRadioOptions(Question question, int index, bool isAr) {
    return Column(
      children: question.options.map((opt) {
        return Obx(() {
          final isSelected = controller.answers[index] == opt.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () => controller.onOptionSelected(index, opt.id, 'radio'),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.appMainColor.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.appMainColor : Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Row(
                        children: [
                          Radio<int>(
                            value: opt.id,
                            groupValue: controller.answers[index],
                            onChanged: (val) => controller.onOptionSelected(index, val, 'radio'),
                            activeColor: AppColors.appMainColor,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              isAr ? opt.arName : opt.enName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isSelected ? AppColors.appMainColor : null,
                                fontWeight: isSelected ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected && opt.type == "comment")
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: TextField(
                          key: ValueKey("opt_comment_${opt.id}"),
                          controller: controller.getCommentController(opt.id),
                          onChanged: (val) => controller.onCommentChanged(opt.id, val),
                          decoration: InputDecoration(
                            hintText: "Please specify".tr,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildCheckboxOptions(Question question, int index, bool isAr) {
    return Column(
      children: question.options.map((opt) {
        return Obx(() {
          final List<int> selectedIds = List<int>.from(controller.answers[index] ?? []);
          final isSelected = selectedIds.contains(opt.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () => controller.onOptionSelected(index, opt.id, 'checkbox'),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.appMainColor.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.appMainColor : Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (val) => controller.onOptionSelected(index, opt.id, 'checkbox'),
                            activeColor: AppColors.appMainColor,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              isAr ? opt.arName : opt.enName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isSelected ? AppColors.appMainColor : null,
                                fontWeight: isSelected ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected && opt.type == "comment")
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: TextField(
                          key: ValueKey("opt_comment_${opt.id}"),
                          controller: controller.getCommentController(opt.id),
                          onChanged: (val) => controller.onCommentChanged(opt.id, val),
                          decoration: InputDecoration(
                            hintText: "Please specify".tr,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Obx(() {
      if (controller.allQuestions.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (!controller.isFirst)
              Expanded(
                child: BPButton(
                  text: "Previous".tr,
                  onPressed: () => controller.previousQuestion(),
                  buttonColor: AppColors.appMainColor,
                  type: BPButtonType.outline,
                ),
              ),
            if (!controller.isFirst) const SizedBox(width: 16),
            Expanded(
              child: BPButton(
                text: controller.isLast ? "Submit".tr : "Next".tr,
                isLoading: controller.isLoading.value,
                onPressed: controller.isCurrentQuestionValid
                    ? () {
                        if (controller.isLast) {
                          BPConfirmationDialog.show(
                            title: "Submit Survey".tr,
                            subtitle: "Are you sure you want to submit your answers?".tr,
                            cancelText: "No".tr,
                            onDone: () {
                              Get.back(); // Close dialog
                              controller.submitSurvey();
                            },
                          );
                        } else {
                          controller.nextQuestion();
                        }
                      }
                    : null,
                buttonColor: controller.isCurrentQuestionValid ? null : AppColors.grey.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    });
  }
}
