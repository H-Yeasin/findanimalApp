import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/partner_ads_repository.dart';
import '../models/partner_ad_model.dart';
import '../sources/partner_ads_remote_source.dart';

final partnerAdsRepositoryProvider = Provider<PartnerAdsRepository>((ref) {
  return PartnerAdsRepositoryImpl(ref.watch(partnerAdsRemoteSourceProvider));
});

class PartnerAdsRepositoryImpl implements PartnerAdsRepository {
  const PartnerAdsRepositoryImpl(this._remoteSource);

  final PartnerAdsRemoteSource _remoteSource;

  @override
  Future<List<PartnerAdModel>> getAllPartnerAds({
    int? page,
    int? limit,
    String? status,
    String? search,
    String? company,
    String? sortBy,
    String? sort,
    double? lat,
    double? lng,
    double? radius,
  }) async {
    final queryParameters = {
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
      if (status != null) 'status': status,
      if (search != null) 'search': search,
      if (company != null) 'company': company,
      if (sortBy != null) 'sortBy': sortBy,
      if (sort != null) 'sort': sort,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (radius != null) 'radius': radius,
    };

    final response = await _remoteSource.getAllPartnerAds(queryParameters: queryParameters);
    final payload = response.data as Map<String, dynamic>;
    // Check for both 'data' directly or 'data.docs' based on API response structure
    final data = payload['data'];
    List<dynamic> items = [];
    
    if (data is Map<String, dynamic> && data['docs'] is List) {
      items = data['docs'];
    } else if (data is List) {
      items = data;
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map(PartnerAdModel.fromJson)
        .toList();
  }

  @override
  Future<List<PartnerAdModel>> getMyCollectionPoints() async {
    final response = await _remoteSource.getMyPartnerAds();
    final payload = response.data as Map<String, dynamic>;
    final items = payload['data'] as List<dynamic>? ?? const [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(PartnerAdModel.fromJson)
        .toList();
  }

  @override
  Future<void> createCollectionPoint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    MultipartFile? image,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      ...?(image == null ? null : {'image': image}),
    });
    await _remoteSource.createCollectionPoint(formData);
  }
}
