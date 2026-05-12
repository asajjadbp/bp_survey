import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:bpsurveys/core/network/exceptions/app_exception.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 60);

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final requestId = _generateRequestId();
    _logRequest(url, "GET", requestId);
    return await _executeRequest(
        () => http.get(Uri.parse(url), headers: headers), requestId);
  }

  Future<dynamic> postJson(String url,
      {Map<String, String>? headers, Object? body}) async {
    final requestId = _generateRequestId();
    _logRequest(url, "POST (RAW-JSON)", requestId, body: body);
    return await _executeRequest(
        () => http.post(
              Uri.parse(url),
              headers: headers ?? {"Content-Type": "application/json"},
              body: jsonEncode(body),
            ),
        requestId);
  }

  Future<dynamic> postForm(String url,
      {Map<String, String>? headers, Map<String, String>? body}) async {
    final requestId = _generateRequestId();
    _logRequest(url, "POST (FORM-DATA)", requestId, body: body);
    return await _executeRequest(
        () => http.post(
              Uri.parse(url),
              headers: headers ??
                  {"Content-Type": "application/x-www-form-urlencoded"},
              body: body,
            ),
        requestId);
  }

  Future<dynamic> put(String url,
      {Map<String, String>? headers, Object? body}) async {
    final requestId = _generateRequestId();
    _logRequest(url, "PUT", requestId, body: body);
    return await _executeRequest(
        () => http.put(
              Uri.parse(url),
              headers: headers ?? {"Content-Type": "application/json"},
              body: jsonEncode(body),
            ),
        requestId);
  }

  Future<dynamic> delete(String url,
      {Map<String, String>? headers, Object? body}) async {
    final requestId = _generateRequestId();
    _logRequest(url, "DELETE", requestId, body: body);
    return await _executeRequest(
        () => http.delete(Uri.parse(url),
            headers: headers, body: body != null ? jsonEncode(body) : null),
        requestId);
  }

  Future<dynamic> multipartPost(
    String url, {
    Map<String, String>? fields,
    Map<String, File>? files,
    Map<String, String>? headers,
    String method = "POST",
  }) async {
    final requestId = _generateRequestId();
    if (kDebugMode) {
      debugPrint(
          'ℹ️ ------------------------------------------------------------------');
      debugPrint('ℹ️ [$requestId] Url: $url');
      debugPrint('ℹ️ [$requestId] Method: MULTIPART $method');
      if (fields != null) debugPrint('ℹ️ [$requestId] Fields: $fields');
      if (files != null)
        debugPrint('ℹ️ [$requestId] Files: ${files.keys.toList()}');
    }

    try {
      var request = http.MultipartRequest(method, Uri.parse(url));
      if (headers != null) request.headers.addAll(headers);
      if (fields != null) request.fields.addAll(fields);

      if (files != null) {
        for (var entry in files.entries) {
          if (await entry.value.exists()) {
            var stream = http.ByteStream(entry.value.openRead());
            var length = await entry.value.length();
            var multipartFile = http.MultipartFile(
              entry.key,
              stream,
              length,
              filename: entry.value.path.split("/").last,
            );
            request.files.add(multipartFile);
          }
        }
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      _logResponse(response, requestId);
      return _processResponse(response);
    } on SocketException {
      _log('❌ [$requestId] Error: No internet connection');
      throw AppException("No internet connection");
    } on TimeoutException {
      _log('❌ [$requestId] Error: Connection timed out');
      throw AppException("File upload timed out");
    } catch (e) {
      _log('❌ [$requestId] Error: $e');
      rethrow;
    }
  }

  Future<dynamic> _executeRequest(
      Future<http.Response> Function() requestFunction,
      String requestId) async {
    try {
      final response = await requestFunction().timeout(_timeout);
      _logResponse(response, requestId);
      return _processResponse(response);
    } on SocketException {
      _log('❌ [$requestId] Error: No internet connection');
      throw AppException("No internet connection");
    } on TimeoutException {
      _log('❌ [$requestId] Error: Connection timed out');
      throw AppException("Connection timed out");
    } catch (e) {
      _log('❌ [$requestId] Error: $e');
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return null;
        final responseData = json.decode(response.body);
        if (responseData != null &&
            responseData["isAction"] == false &&
            responseData["data"] != null &&
            responseData["data"]
                .toString()
                .toLowerCase()
                .contains('please update the application from store')) {
          throw AppException(responseData["data"].toString());
        }
        return responseData;
      case 400:
        throw AppException("Bad Request: ${response.body}");
      case 401:
        throw AppException("Unauthorized");
      case 403:
        throw AppException("Forbidden");
      case 404:
        throw AppException("Not Found");
      case 500:
        throw AppException("Server Error: ${response.statusCode}");
      default:
        throw AppException("An Unexpected Error Occur, Please try again later");
    }
  }

  void _logRequest(String url, String method, String requestId,
      {Object? body}) {
    if (!kDebugMode) return;
    debugPrint(
        'ℹ️ ------------------------------------------------------------------');
    debugPrint('ℹ️ [$requestId] Url: $url');
    debugPrint('ℹ️ [$requestId] Method: $method');
    if (body != null) {
      debugPrint('ℹ️ [$requestId] Request Body: $body');
    }
  }

  void _logResponse(http.Response response, final requestId) {
    if (!kDebugMode) return;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('✅ [$requestId] Status Code: ${response.statusCode}');
      debugPrint('✅ [$requestId] Response Body: ${response.body}');
    } else {
      debugPrint('❌ [$requestId] Status Code: ${response.statusCode}');
      debugPrint('❌ [$requestId] Response Body: ${response.body}');
    }
    debugPrint(
        '---------------------------------------------------------------------\n');
  }

  String _generateRequestId() {
    return 'REQ-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9999)}';
  }

  void _log(String message) {
    if (kDebugMode) debugPrint(message);
  }
}
