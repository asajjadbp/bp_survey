import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bpsurveys/data/models/response_models/login_response_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static late SharedPreferences _prefs;

  static const String _keyLanguage = 'selected_language';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserData = 'user_data';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Language
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_keyLanguage, languageCode);
  }

  String getLanguage() {
    return _prefs.getString(_keyLanguage) ?? 'en';
  }

  // Login Status
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // User Data
  Future<void> saveUser(UserData user) async {
    await _prefs.setString(_keyUserData, jsonEncode(user.toJson()));
  }

  UserData? getUser() {
    String? userStr = _prefs.getString(_keyUserData);
    if (userStr != null) {
      return UserData.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  // Logout - preserves language settings
  Future<void> logout() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserData);
  }
}
