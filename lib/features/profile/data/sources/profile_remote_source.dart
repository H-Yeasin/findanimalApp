import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_provider.dart';

final profileRemoteSourceProvider = Provider<ProfileRemoteSource>((ref) {
  return ProfileRemoteSource(ref.watch(apiClientProvider));
});

class ProfileRemoteSource {
  const ProfileRemoteSource(this._apiClient);

  final ApiClient _apiClient;

  Future<void> getProfile() async {
    await _apiClient.get('/user/get-my-profile');
  }

  Future<void> updateProfile(Map<String, dynamic> payload) async {
    await _apiClient.put('/user/update-user', data: payload);
  }

  Future<void> deleteAccount(String password) async {
    await _apiClient.delete('/user/delete-account', data: {'password': password});
  }

  Future<void> submitSupportMessage(Map<String, dynamic> payload) async {
    await _apiClient.post('/support-messages', data: payload);
  }
}
