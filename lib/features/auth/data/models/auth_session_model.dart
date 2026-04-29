import 'auth_user_model.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final AuthUserModel user;

  factory AuthSessionModel.fromApiData(Map<String, dynamic> data) {
    return AuthSessionModel(
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
      user: AuthUserModel.fromJson(data),
    );
  }
}
