import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpsurveys/core/localizations/languages.dart';
import 'package:bpsurveys/core/constants/app_colors.dart';
import 'package:bpsurveys/data/sources/local/storage_service.dart';
import 'package:bpsurveys/core/routes/app_pages.dart';
import 'package:bpsurveys/core/routes/app_routes.dart';
import 'package:bpsurveys/core/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storageService = StorageService();
  await storageService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = StorageService();
    String currentLang = storageService.getLanguage();
    bool isLoggedIn = storageService.isLoggedIn();

    return GetMaterialApp(
      title: 'BP Survey',
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: Locale(currentLang),
      fallbackLocale: const Locale('en'),
      theme: ThemeData(
        primaryColor: AppColors.appMainColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.appMainColor,
          primary: AppColors.appMainColor,
        ),
        useMaterial3: true,
      ),
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      getPages: AppPages.pages,
      initialBinding: InitialBinding(),
    );
  }
}
