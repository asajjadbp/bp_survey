import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpsurveys/core/constants/app_colors.dart';
import 'package:bpsurveys/core/constants/app_text_styles.dart';
import 'package:bpsurveys/presentation/common/bp_app_bar.dart';
import 'package:bpsurveys/data/models/response_models/get_visits_response_model.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/completed_surveys_controller.dart';

class CompletedSurveysView extends GetView<CompletedSurveysController> {
  const CompletedSurveysView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          BPAppBar(
            title: "Completed Surveys".tr,
            onBackTap: () => Get.back(),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.visits.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.fetchVisits,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.visits.length,
                  itemBuilder: (context, index) {
                    final visit = controller.visits[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        AppRoutes.surveyDetails,
                        arguments: visit.visitId,
                      ),
                      child: _buildVisitCard(visit),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 64, color: AppColors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            "No completed surveys found".tr,
            style: AppTextStyles.h3.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitCard(VisitItem visit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 6,
                color: AppColors.appMainColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Visit ID: #${visit.visitId}",
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.appMainColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "COMPLETED",
                              style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFF059669),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.calendar_today_outlined, "Date", visit.workingDate),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.access_time, "Check In", visit.checkIn.split(' ').last),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.timer_outlined, "Working Time", "${visit.workingMinutes} mins"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8)),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: const Color(0xFF334155),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
