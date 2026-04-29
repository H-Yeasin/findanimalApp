import 'package:dio/dio.dart';
import '../../data/models/partner_ad_model.dart';

abstract class PartnerAdsRepository {
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
  });
  Future<List<PartnerAdModel>> getMyCollectionPoints();
  Future<void> createCollectionPoint({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    MultipartFile? image,
  });
}
