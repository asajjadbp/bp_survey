import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpsurveys/core/constants/app_colors.dart';
import 'package:bpsurveys/core/constants/app_text_styles.dart';
import 'package:bpsurveys/data/sources/local/storage_service.dart';
import 'package:bpsurveys/presentation/modules/auth/controllers/login_controller.dart';
import 'package:bpsurveys/presentation/common/bp_button.dart';
import 'package:bpsurveys/presentation/common/bp_input_field.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String newLang = storage.getLanguage() == 'en' ? 'ar' : 'en';
          await storage.saveLanguage(newLang);
          Get.updateLocale(Locale(newLang));
        },
        backgroundColor: AppColors.appMainColor,
        icon: const Icon(Icons.language, color: Colors.white),
        label: Text(
          storage.getLanguage() == 'en' ? 'العربية' : 'English',
          style: AppTextStyles.button.copyWith(fontSize: 16),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to BP Survey'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 48),
                BPInputField(
                  hintText: 'Username'.tr,
                  prefixIcon: Icons.person_outline,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required'.tr;
                    }
                    return null;
                  },
                  onChanged: (value) => controller.userName.value = value,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => BPInputField(
                    hintText: 'Password'.tr,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: GestureDetector(
                      onTap: () => controller.showPassword.value = !controller.showPassword.value,
                      child: Icon(
                        controller.showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    obscureText: controller.showPassword.value,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required'.tr;
                      }
                      return null;
                    },
                    onChanged: (value) => controller.password.value = value,
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => BPButton(
                    text: 'Login'.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.login(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
