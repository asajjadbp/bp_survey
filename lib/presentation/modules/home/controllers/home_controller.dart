import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bpsurveys/data/sources/local/storage_service.dart';
import 'package:bpsurveys/data/models/response_models/login_response_model.dart';
import 'package:bpsurveys/core/routes/app_routes.dart';

class HomeController extends GetxController {
  final userData = Rxn<UserData>();
  final currentDate = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    updateDate();
  }

  void loadUserData() {
    userData.value = StorageService().getUser();
  }

  void updateDate() {
    currentDate.value = DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  void logout() async {
    await StorageService().logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
