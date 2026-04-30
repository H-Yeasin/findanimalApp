import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';

final reportsRemoteSourceProvider = Provider<ReportsRemoteSource>((ref) {
  return ReportsRemoteSource(ref.watch(apiClientProvider));
});

class ReportsRemoteSource {
  const ReportsRemoteSource(this._apiClient);

  final ApiClient _apiClient;

  Future<dynamic> getAllReports({Map<String, dynamic>? query}) async {
    final response = await _apiClient.get(
      ApiEndpoints.getAllReports,
      queryParameters: query,
    );
    return response.data;
  }

  Future<dynamic> getReportById(String id) async {
    final response = await _apiClient.get(
      ApiEndpoints.getReportById(id),
    );
    return response.data;
  }
}
