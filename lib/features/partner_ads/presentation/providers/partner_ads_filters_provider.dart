import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartnerAdsFilters {
  final int page;
  final int limit;
  final String? search;
  final String? sortBy;
  final String? sort;
  final String? status;
  final double? lat;
  final double? lng;
  final double? radius;

  PartnerAdsFilters({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.sortBy,
    this.sort,
    this.status = 'active',
    this.lat,
    this.lng,
    this.radius,
  });

  PartnerAdsFilters copyWith({
    int? page,
    int? limit,
    String? search,
    String? sortBy,
    String? sort,
    String? status,
    double? lat,
    double? lng,
    double? radius,
  }) {
    return PartnerAdsFilters(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      sort: sort ?? this.sort,
      status: status ?? this.status,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      radius: radius ?? this.radius,
    );
  }
}

class PartnerAdsFiltersNotifier extends StateNotifier<PartnerAdsFilters> {
  PartnerAdsFiltersNotifier() : super(PartnerAdsFilters());

  void setPage(int page) => state = state.copyWith(page: page);
  void setSearch(String? search) =>
      state = state.copyWith(search: search, page: 1);
  void setSort(String? sortBy, String? sort) =>
      state = state.copyWith(sortBy: sortBy, sort: sort, page: 1);
  void setStatus(String? status) =>
      state = state.copyWith(status: status, page: 1);

  void setLocation(double? lat, double? lng, double? radius) {
    if (radius == 0) {
      state = PartnerAdsFilters(
        page: 1,
        limit: state.limit,
        search: state.search,
        sortBy: state.sortBy,
        sort: state.sort,
        status: state.status,
      );
    } else {
      state = state.copyWith(
        lat: lat,
        lng: lng,
        radius: radius,
        page: 1,
      );
    }
  }

  void reset() => state = PartnerAdsFilters();
}

final partnerAdsFiltersProvider =
    StateNotifierProvider<PartnerAdsFiltersNotifier, PartnerAdsFilters>((ref) {
      return PartnerAdsFiltersNotifier();
    });
