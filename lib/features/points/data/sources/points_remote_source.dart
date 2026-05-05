import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_provider.dart';

final pointsRemoteSourceProvider = Provider<PointsRemoteSource>((ref) {
  return PointsRemoteSource(ref.watch(apiClientProvider));
});

class PointsRemoteSource {
  const PointsRemoteSource(this._apiClient);

  final ApiClient _apiClient;

  Future<void> getMyPoints() async {
    await _apiClient.get('/points/get-my-points');
  }

  Future<Map<String, dynamic>> getAllRewards({
    String? category,
    String? type,
    bool isActive = true,
  }) async {
    final queryParams = {
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      'isActive': isActive,
    };

    final response = await _apiClient.get(
      '/rewards/get-all-rewards',
      queryParameters: queryParams,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> redeemReward(String rewardId) async {
    final response = await _apiClient.post('/rewards/redeem-reward/$rewardId');
    return response.data;
  }

  Future<Map<String, dynamic>> getMyRedemptions() async {
    final response = await _apiClient.get('/rewards/get-my-redemptions');
    return response.data;
  }
}
