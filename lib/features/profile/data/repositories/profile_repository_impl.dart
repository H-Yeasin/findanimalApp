import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
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
    final response = await _apiClient.get('/user/get-my-profile');
    return ProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
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
}
