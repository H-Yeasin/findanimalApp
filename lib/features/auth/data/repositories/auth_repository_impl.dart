import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_session_model.dart';
import '../models/login_request_model.dart';
import '../models/register_partner_request_model.dart';
import '../models/register_request_model.dart';
import '../sources/auth_remote_source.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteSourceProvider));
});

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteSource);

  final AuthRemoteSource _remoteSource;

  @override
  Future<AuthSessionModel> login(LoginRequestModel request) async {
    try {
      return await _remoteSource.login(request);
    } on DioException catch (error) {
      throw Exception(NetworkExceptions.fromDio(error));
    }
  }

  @override
  Future<void> registerUser(RegisterRequestModel request) async {
    try {
      await _remoteSource.registerUser(request);
    } on DioException catch (error) {
      throw Exception(NetworkExceptions.fromDio(error));
    }
  }

  @override
  Future<void> registerPartner(RegisterPartnerRequestModel request) async {
    try {
      await _remoteSource.registerPartner(request);
    } on DioException catch (error) {
      throw Exception(NetworkExceptions.fromDio(error));
    }
  }

  @override
  Future<void> verifyAccount({
    required String email,
    required String otp,
  }) async {
    try {
      await _remoteSource.verifyAccount(email: email, otp: otp);
    } on DioException catch (error) {
      throw Exception(NetworkExceptions.fromDio(error));
    }
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    try {
      await _remoteSource.forgetPassword(email: email);
    } on DioException catch (error) {
      throw Exception(NetworkExceptions.fromDio(error));
    }
  }

  @override
  Future<String> verifyPasswordOtp({
    required String email,
    required String otp,
  }) async {
    try {
      return await _remoteSource.verifyPasswordOtp(email: email, otp: otp);
    } on DioException catch (error) {
      throw Exception(NetworkExceptions.fromDio(error));
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      await _remoteSource.resetPassword(
        token: token,
        password: password,
        confirmPassword: confirmPassword,
      );
    } on DioException catch (error) {
      throw Exception(NetworkExceptions.fromDio(error));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteSource.logout();
    } on DioException catch (error) {
      throw Exception(NetworkExceptions.fromDio(error));
    }
  }

  @override
  Future<String> generateAccessToken(String refreshToken) async {
    try {
      return await _remoteSource.generateAccessToken(refreshToken);
    } on DioException catch (error) {
      throw Exception(NetworkExceptions.fromDio(error));
    }
  }
}
