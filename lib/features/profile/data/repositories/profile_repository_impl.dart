import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(apiClientProvider));
});

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ProfileModel> getMyProfile() async {
    final response = await _apiClient.get(
      ApiEndpoints.myProfile,
      options: Options(responseType: ResponseType.plain),
    );
    try {
      return compute(parseProfileResponse, response.data as String? ?? '');
    } catch (e, stack) {
      print('DEBUG: ProfileModel.fromJson error: $e');
      print('DEBUG: Stack: $stack');
      rethrow;
    }
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    final hasBinary = data.values.any((value) => value is MultipartFile);
    final payload = hasBinary ? FormData.fromMap(data) : data;
    final response = await _apiClient.patch(
      '/user/update-user',
      data: payload,
      options: hasBinary
          ? Options(contentType: Headers.multipartFormDataContentType)
          : null,
    );
    return ProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> updateFcmToken(String token) async {
    await _apiClient.patch('/user/update-fcm-token', data: {'fcmToken': token});
  }

  @override
  Future<void> deleteAccount(String password) async {
    await _apiClient.delete('/user/delete-account', data: {'password': password});
  }

  @override
  Future<void> submitSupportMessage(Map<String, dynamic> data) async {
    await _apiClient.post('/support-messages', data: data);
  }
}

ProfileModel parseProfileResponse(String responseBody) {
  final decoded = jsonDecode(responseBody);
  if (decoded is! Map) {
    throw const FormatException('Profile response must be a JSON object.');
  }

  final envelope = Map<String, dynamic>.from(decoded);
  final data = envelope['data'];
  if (data is! Map) {
    throw const FormatException('Profile response is missing data.');
  }

  return ProfileModel.fromJson(Map<String, dynamic>.from(data));
}
