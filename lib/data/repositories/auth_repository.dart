import 'package:bpsurveys/core/network/api_client.dart';
import 'package:bpsurveys/core/network/url/app_urls.dart';
import 'package:bpsurveys/core/utils/result.dart';
import 'package:bpsurveys/data/models/request_models/login_request_model.dart';
import 'package:bpsurveys/data/models/response_models/login_response_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<Result<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.postForm(
        AppUrls.loginApi,
        body: request.toJson(),
      );

      if (response != null) {
        final loginResponse = LoginResponse.fromJson(response);
        if (loginResponse.status) {
          return Success(loginResponse);
        } else {
          return Failure(loginResponse.msg);
        }
      } else {
        return const Failure('Empty response from server');
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
