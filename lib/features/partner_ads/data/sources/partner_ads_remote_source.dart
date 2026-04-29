import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';

final partnerAdsRemoteSourceProvider = Provider<PartnerAdsRemoteSource>((ref) {
  return PartnerAdsRemoteSource(ref.watch(apiClientProvider));
});

class PartnerAdsRemoteSource {
  const PartnerAdsRemoteSource(this._apiClient);

  final ApiClient _apiClient;

  Future<Response<dynamic>> getAllPartnerAds({Map<String, dynamic>? queryParameters}) async {
    return _apiClient.get(ApiEndpoints.getAllPartnerAds, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> getMyPartnerAds() async {
    return _apiClient.get(ApiEndpoints.getMyPartnerAds);
  }

  Future<Response<dynamic>> createCollectionPoint(FormData formData) async {
    return _apiClient.post(ApiEndpoints.createCollectionPoint, data: formData);
  }
}
