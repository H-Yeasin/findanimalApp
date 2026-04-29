import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/partner_ad_model.dart';
import '../../data/repositories/partner_ads_repository_impl.dart';
import 'partner_ads_filters_provider.dart';

final partnerCollectionPointsProvider =
    FutureProvider.autoDispose<List<PartnerAdModel>>((ref) async {
      final repository = ref.watch(partnerAdsRepositoryProvider);
      return repository.getMyCollectionPoints();
    });

final allCollectionPointsProvider =
    FutureProvider.autoDispose<List<PartnerAdModel>>((ref) async {
      final repository = ref.watch(partnerAdsRepositoryProvider);
      final filters = ref.watch(partnerAdsFiltersProvider);
      
      return repository.getAllPartnerAds(
        page: filters.page,
        limit: filters.limit,
        search: filters.search,
        sortBy: filters.sortBy,
        sort: filters.sort,
        status: filters.status,
        lat: filters.lat,
        lng: filters.lng,
        radius: filters.radius,
      );
    });
