import 'package:get/get.dart';
import 'package:bpsurveys/core/network/api_client.dart';
import 'package:bpsurveys/data/repositories/survey_repository.dart';
import '../controllers/survey_controller.dart';

class SurveyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SurveyRepository(Get.find<ApiClient>()));
    Get.lazyPut<SurveyController>(() => SurveyController());
  }
}
