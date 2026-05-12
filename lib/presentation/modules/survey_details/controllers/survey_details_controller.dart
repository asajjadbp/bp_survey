import 'package:get/get.dart';
import 'package:bpsurveys/data/repositories/survey_repository.dart';
import 'package:bpsurveys/data/models/response_models/get_survey_details_response_model.dart';
import 'package:bpsurveys/core/utils/result.dart';
import 'package:bpsurveys/data/sources/local/storage_service.dart';

class SurveyDetailsController extends GetxController {
  final SurveyRepository _repository = Get.find<SurveyRepository>();
  final storage = StorageService();

  final isLoading = false.obs;
  final surveyDetails = Rxn<SurveyDetailsData>();
  final int visitId;

  SurveyDetailsController({required this.visitId});

  @override
  void onInit() {
    super.onInit();
    fetchSurveyDetails();
  }

  Future<Result<void>> fetchSurveyDetails() async {
    final user = storage.getUser();
    if (user == null) {
      Get.snackbar("Error".tr, "User session expired".tr);
      return Failure("Session expired");
    }

    isLoading.value = true;
    final result = await _repository.getSurveyDetails(
      visitId: visitId,
      userId: user.username,
    );
    isLoading.value = false;

    switch (result) {
      case Success<GetSurveyDetailsResponse>(data: final response):
        surveyDetails.value = response.data;
        return const Success(null);
      case Failure<GetSurveyDetailsResponse>(message: final msg):
        Get.snackbar("Error".tr, msg);
        return Failure(msg);
    }
  }

  String getLanguage() => storage.getLanguage();
}
