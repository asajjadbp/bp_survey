import 'package:get/get.dart';
import 'package:bpsurveys/core/network/api_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient(), permanent: true);
  }
}
