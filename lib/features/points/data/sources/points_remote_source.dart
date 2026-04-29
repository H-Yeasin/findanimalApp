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
}
