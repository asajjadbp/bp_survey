import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpsurveys/data/repositories/auth_repository.dart';
import 'package:bpsurveys/data/models/request_models/login_request_model.dart';
import 'package:bpsurveys/core/utils/result.dart';
import 'package:bpsurveys/data/sources/local/storage_service.dart';
import 'package:bpsurveys/core/routes/app_routes.dart';

class LoginController extends GetxController {
  final userName = "".obs;
  final password = "".obs;
  final isLoading = false.obs;
  final showPassword = true.obs;
  final formKey = GlobalKey<FormState>();

  final AuthRepository _authRepository = Get.find<AuthRepository>();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    
    final request = LoginRequest(
      username: userName.value,
      password: password.value,
    );

    final result = await _authRepository.login(request);
    
    isLoading.value = false;

    switch (result) {
      case Success(data: final loginResponse):
        final storage = StorageService();
        await storage.setLoggedIn(true);
        if (loginResponse.data.isNotEmpty) {
          await storage.saveUser(loginResponse.data[0]);
        }
        Get.snackbar("Success".tr, loginResponse.msg);
        Get.offAllNamed(AppRoutes.home);
        break;
      case Failure(message: final msg):
        Get.snackbar("Error".tr, msg);
        break;
    }
  }
}