import 'package:get/get.dart';
import 'package:bpsurveys/data/repositories/survey_repository.dart';
import 'package:bpsurveys/core/network/api_client.dart';
import '../controllers/survey_details_controller.dart';

class SurveyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final int visitId = Get.arguments as int;
    
    Get.lazyPut<SurveyRepository>(
      () => SurveyRepository(Get.find<ApiClient>()),
    );
    
    Get.lazyPut<SurveyDetailsController>(
      () => SurveyDetailsController(visitId: visitId),
    );
  }
}
