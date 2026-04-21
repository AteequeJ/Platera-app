import '../../models/auth_models.dart';
import '../api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.dio.post('auth/register', data: request.toJson());
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post('auth/login', data: request.toJson());
      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.token != null) {
        await _apiClient.setToken(authResponse.token!);
      }
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await _apiClient.dio.post('auth/changepassword', data: request.toJson());
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserProfile> getProfile() async {
    try {
      final response = await _apiClient.dio.get('auth/getProfile');
      return UserProfile.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _apiClient.clearToken();
  }
}
