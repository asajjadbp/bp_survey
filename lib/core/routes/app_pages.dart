import 'package:get/get.dart';
import 'package:bpsurveys/presentation/modules/auth/views/login_view.dart';
import 'package:bpsurveys/presentation/modules/auth/bindings/login_binding.dart';
import 'package:bpsurveys/presentation/modules/home/views/home_view.dart';
import 'package:bpsurveys/presentation/modules/home/bindings/home_binding.dart';
import 'package:bpsurveys/presentation/modules/survey/views/survey_view.dart';
import 'package:bpsurveys/presentation/modules/survey/bindings/survey_binding.dart';
import 'package:bpsurveys/presentation/modules/completed_surveys/views/completed_surveys_view.dart';
import 'package:bpsurveys/presentation/modules/completed_surveys/bindings/completed_surveys_binding.dart';
import 'package:bpsurveys/presentation/modules/survey_details/views/survey_details_view.dart';
import 'package:bpsurveys/presentation/modules/survey_details/bindings/survey_details_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.survey,
      page: () => const SurveyView(),
      binding: SurveyBinding(),
    ),
    GetPage(
      name: AppRoutes.completedSurveys,
      page: () => const CompletedSurveysView(),
      binding: CompletedSurveysBinding(),
    ),
    GetPage(
      name: AppRoutes.surveyDetails,
      page: () => const SurveyDetailsView(),
      binding: SurveyDetailsBinding(),
    ),
  ];
}
