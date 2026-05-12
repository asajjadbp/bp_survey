import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpsurveys/core/constants/app_colors.dart';
import 'package:bpsurveys/core/constants/app_text_styles.dart';
import 'package:bpsurveys/presentation/common/bp_app_bar.dart';
import 'package:bpsurveys/data/models/response_models/get_survey_details_response_model.dart';
import '../controllers/survey_details_controller.dart';

class SurveyDetailsView extends GetView<SurveyDetailsController> {
  const SurveyDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isAr = controller.getLanguage() == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          BPAppBar(
            title: "Survey Details".tr,
            onBackTap: () => Get.back(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final details = controller.surveyDetails.value;
              if (details == null || details.surveyData.isEmpty) {
                return Center(child: Text("No details found".tr));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: details.surveyData.length,
                itemBuilder: (context, index) {
                  final item = details.surveyData[index];
                  return _buildQuestionAnswerCard(index,item, isAr);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAnswerCard(int index, SurveyAnswerDetail item, bool isAr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.appMainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isAr ? item.accessPoint.arName.trim() : item.accessPoint.enName.trim(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.appMainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isAr ? "${index + 1}- ${item.arQuestion}" : "${index + 1}- ${item.enQuestion}",
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Answer".tr,
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.answer.answer.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.appMainColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (item.answer.comment.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    "Comment".tr,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.answer.comment,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF334155),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
