import '../../models/auth_models.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<AuthResponse> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    return await _authService.login(request);
  }

  Future<AuthResponse> register(String name, String email, String password) async {
    final request = RegisterRequest(name: name, email: email, password: password);
    return await _authService.register(request);
  }

  Future<AuthResponse> changePassword(String currentPassword, String newPassword) async {
    final request = ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword);
    return await _authService.changePassword(request);
  }

  Future<UserProfile> getProfile() async {
    return await _authService.getProfile();
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
