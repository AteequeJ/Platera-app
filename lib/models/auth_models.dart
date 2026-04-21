class RegisterRequest {
  final String name;
  final String email;
  final String password;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };
}

class UserProfile {
  final int id;
  final String name;
  final String email;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class AuthResponse {
  final String? token;
  final UserProfile? user;
  final String? message;

  AuthResponse({
    this.token,
    this.user,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Check if response is nested in 'data'
    final data = json['data'] is Map<String, dynamic> ? json['data'] : json;
    
    return AuthResponse(
      token: data['token'] ?? data['accessToken'] ?? json['token'] ?? json['accessToken'],
      user: data['user'] != null ? UserProfile.fromJson(data['user']) : (json['user'] != null ? UserProfile.fromJson(json['user']) : null),
      message: json['message'] ?? data['message'],
    );
  }
}
