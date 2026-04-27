import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

class ApiClient {
  // Use 10.0.2.2 for Android Emulator to access localhost on host machine
  static String get baseUrl {
    if (kIsWeb) return 'https://platera-backend.onrender.com/api/';
    if (Platform.isAndroid && kDebugMode) return 'http://10.0.2.2:3000/api/';
    return 'https://platera-backend.onrender.com/api/';
  }

  late Dio dio;
  static SharedPreferences? _prefs;

  /// Global initialization for SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Use the cached _prefs instead of awaiting SharedPreferences.getInstance() every time
          final token = _prefs?.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            debugPrint(
              '🔑 Sending Token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...',
            );
          } else {
            debugPrint('⚠️ No Token Found in SharedPreferences');
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // Global Logout or Refresh logic could go here
          }
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<void> setToken(String token) async {
    debugPrint(
      '💾 Saving New Token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...',
    );
    await _prefs?.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    await _prefs?.remove('auth_token');
  }

  Future<String?> getToken() async {
    return _prefs?.getString('auth_token');
  }
}
