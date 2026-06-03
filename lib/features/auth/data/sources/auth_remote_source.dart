import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/auth_session_model.dart';
import '../models/login_request_model.dart';
import '../models/register_partner_request_model.dart';
import '../models/register_request_model.dart';

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  return AuthRemoteSource(ref.watch(apiClientProvider));
});


class AuthRemoteSource {
  const AuthRemoteSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSessionModel> login(LoginRequestModel request) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    final data = _dataMap(response.data);
    final session = AuthSessionModel.fromApiData(data);
    if (session.accessToken.isEmpty) {
      throw Exception(
        _message(response.data, fallback: 'Invalid login response'),
      );
    }
    return session;
  }

  Future<AuthSessionModel> googleLogin(String idToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.googleLogin,
      data: {'idToken': idToken},
    );

    final data = _dataMap(response.data);
    final session = AuthSessionModel.fromApiData(data);
    if (session.accessToken.isEmpty) {
      throw Exception(
        _message(response.data, fallback: 'Invalid Google login response'),
      );
    }
    return session;
  }

  Future<AuthSessionModel> appleLogin({
    required String idToken,
    String? firstName,
    String? lastName,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.appleLogin,
      data: {
        'idToken': idToken,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
      },
    );

    final data = _dataMap(response.data);
    final session = AuthSessionModel.fromApiData(data);
    if (session.accessToken.isEmpty) {
      throw Exception(
        _message(response.data, fallback: 'Invalid Apple login response'),
      );
    }
    return session;
  }

  Future<void> registerUser(RegisterRequestModel request) async {
    await _apiClient.post(ApiEndpoints.registerUser, data: request.toJson());
  }

  Future<void> registerPartner(RegisterPartnerRequestModel request) async {
    await _apiClient.post(
      ApiEndpoints.registerPartner,
      data: await request.toFormData(),
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
  }

  Future<void> verifyAccount({
    required String email,
    required String otp,
  }) async {
    await _apiClient.post(
      ApiEndpoints.verifyAccount,
      data: {'email': email, 'otp': otp},
    );
  }

  Future<void> forgetPassword({required String email}) async {
    await _apiClient.post(ApiEndpoints.forgetPassword, data: {'email': email});
  }

  Future<String> verifyPasswordOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data: {'email': email, 'otp': otp},
    );

    final data = _dataMap(response.data);
    return data['token'] as String? ?? '';
  }

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    await _apiClient.post(
      ApiEndpoints.resetPassword(token),
      data: {'password': password, 'confirmPassword': confirmPassword},
    );
  }

  Future<void> logout() async {
    await _apiClient.post(ApiEndpoints.logout);
  }

  Future<String> generateAccessToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.generateAccessToken,
      options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
    );

    final data = _dataMap(response.data);
    final token = data['accessToken'] as String? ?? '';
    if (token.isEmpty) {
      throw Exception(
        _message(response.data, fallback: 'Failed to refresh access token'),
      );
    }
    return token;
  }

  Map<String, dynamic> _dataMap(dynamic raw) {
    if (raw is! Map) {
      return <String, dynamic>{};
    }

    final envelope = Map<String, dynamic>.from(raw);
    final data = envelope['data'];

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return <String, dynamic>{};
  }

  String _message(dynamic raw, {required String fallback}) {
    if (raw is! Map) {
      return fallback;
    }

    final envelope = Map<String, dynamic>.from(raw);
    return envelope['message'] as String? ?? fallback;
  }
}
