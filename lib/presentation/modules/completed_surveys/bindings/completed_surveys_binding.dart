import 'package:get/get.dart';
import 'package:bpsurveys/data/repositories/survey_repository.dart';
import 'package:bpsurveys/core/network/api_client.dart';
import '../controllers/completed_surveys_controller.dart';

class CompletedSurveysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SurveyRepository>(
      () => SurveyRepository(Get.find<ApiClient>()),
    );
    Get.lazyPut<CompletedSurveysController>(
      () => CompletedSurveysController(),
    );
  }
}
