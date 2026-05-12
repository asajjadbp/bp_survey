import 'package:get/get.dart';
import 'package:bpsurveys/core/network/api_client.dart';
import 'package:bpsurveys/data/repositories/auth_repository.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository(Get.find<ApiClient>()));
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
