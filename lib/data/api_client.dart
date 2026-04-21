import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiClient {
  // Use 10.0.2.2 for Android Emulator to access localhost on host machine
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api/';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000/api/';
    return 'http://localhost:3000/api/';
  }

  late Dio dio;
  static SharedPreferences? _prefs;

  /// Global initialization for SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Use the cached _prefs instead of awaiting SharedPreferences.getInstance() every time
        final token = _prefs?.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          // Global Logout or Refresh logic could go here
        }
        return handler.next(e);
      },
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<void> setToken(String token) async {
    await _prefs?.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    await _prefs?.remove('auth_token');
  }

  Future<String?> getToken() async {
    return _prefs?.getString('auth_token');
  }
}
