import 'package:get/get.dart';
import 'package:bpsurveys/data/repositories/survey_repository.dart';
import 'package:bpsurveys/data/models/response_models/get_visits_response_model.dart';
import 'package:bpsurveys/core/utils/result.dart';
import 'package:bpsurveys/data/sources/local/storage_service.dart';

class CompletedSurveysController extends GetxController {
  final SurveyRepository _repository = Get.find<SurveyRepository>();
  final storage = StorageService();

  final isLoading = false.obs;
  final visits = <VisitItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVisits();
  }

  Future<void> fetchVisits() async {
    final user = storage.getUser();
    if (user == null) {
      Get.snackbar("Error".tr, "User session expired".tr);
      return;
    }

    isLoading.value = true;
    final result = await _repository.getVisits(user.username);
    isLoading.value = false;

    switch (result) {
      case Success<GetVisitsResponse>(data: final response):
        if (response.data != null) {
          visits.assignAll(response.data!.visits);
        }
        break;
      case Failure<GetVisitsResponse>(message: final msg):
        Get.snackbar("Error".tr, msg);
        break;
    }
  }

  String getLanguage() => storage.getLanguage();
}
