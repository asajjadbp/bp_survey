import 'package:bpsurveys/core/network/api_client.dart';
import 'package:bpsurveys/core/network/url/app_urls.dart';
import 'package:bpsurveys/core/utils/result.dart';
import 'package:bpsurveys/data/models/response_models/survey_questions_response_model.dart';
import 'package:bpsurveys/data/models/response_models/save_survey_response_model.dart';
import 'package:bpsurveys/data/models/request_models/save_survey_request_model.dart';
import 'package:bpsurveys/data/models/response_models/get_visits_response_model.dart';
import 'package:bpsurveys/data/models/response_models/get_survey_details_response_model.dart';

class SurveyRepository {
  final ApiClient _apiClient;

  SurveyRepository(this._apiClient);

  Future<Result<SurveyQuestionsResponse>> getQuestions({
    required dynamic userId,
    required String checkinGps,
  }) async {
    try {
      final response = await _apiClient.postForm(
        AppUrls.getQuestions,
        body: {
          'user_id': userId.toString(),
          'checkin_gps': checkinGps,
        },
      );

      if (response != null) {
        final surveyResponse = SurveyQuestionsResponse.fromJson(response);
        if (surveyResponse.status) {
          return Success(surveyResponse);
        } else {
          return Failure(surveyResponse.msg);
        }
      } else {
        return const Failure('Empty response from server');
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<SaveSurveyResponse>> saveSurvey(SaveSurveyRequest request) async {
    try {
      final response = await _apiClient.postForm(
        AppUrls.saveSurvey,
        body: request.toJson(),
      );

      if (response != null) {
        final saveResponse = SaveSurveyResponse.fromJson(response);
        if (saveResponse.status) {
          return Success(saveResponse);
        } else {
          return Failure(saveResponse.msg);
        }
      } else {
        return const Failure('Empty response from server');
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<GetVisitsResponse>> getVisits(dynamic userId) async {
    try {
      final response = await _apiClient.postForm(
        AppUrls.getVisits,
        body: {
          'user_id': userId.toString(),
        },
      );

      if (response != null) {
        final visitsResponse = GetVisitsResponse.fromJson(response);
        if (visitsResponse.status) {
          return Success(visitsResponse);
        } else {
          return Failure(visitsResponse.msg);
        }
      } else {
        return const Failure('Empty response from server');
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<GetSurveyDetailsResponse>> getSurveyDetails({
    required int visitId,
    required dynamic userId,
  }) async {
    try {
      final response = await _apiClient.postForm(
        AppUrls.getSurvey,
        body: {
          'visit_id': visitId.toString(),
          'user_id': userId.toString(),
        },
      );

      if (response != null) {
        final surveyDetailsResponse = GetSurveyDetailsResponse.fromJson(response);
        if (surveyDetailsResponse.status) {
          return Success(surveyDetailsResponse);
        } else {
          return Failure(surveyDetailsResponse.msg);
        }
      } else {
        return const Failure('Empty response from server');
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
