import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/providers/location_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/app_top_bar.dart';
import 'collections_points_details.dart';
import 'package:hesteka_frontend/features/Collection_Point/widgets/collection_point_filters.dart';
import 'package:hesteka_frontend/features/Collection_Point/widgets/collection_points_list.dart';
import 'package:hesteka_frontend/features/Collection_Point/widgets/collection_points_map.dart';
import 'package:hesteka_frontend/features/Collection_Point/widgets/collection_points_pagination.dart';
import 'package:hesteka_frontend/features/partner_ads/data/models/partner_ad_model.dart';
import 'package:hesteka_frontend/features/partner_ads/presentation/providers/partner_ads_filters_provider.dart';
import 'package:hesteka_frontend/features/partner_ads/presentation/providers/partner_collection_points_provider.dart';

class CollectionPointScreen extends ConsumerStatefulWidget {
  const CollectionPointScreen({super.key});

  @override
  ConsumerState<CollectionPointScreen> createState() =>
      _CollectionPointScreenState();
}

class _CollectionPointScreenState extends ConsumerState<CollectionPointScreen> {
  static const _brandPrimary = AppColors.brandPrimary;
  static const _cardBg = Color(0xFFFFF6E5);

  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  PartnerAdModel? _selectedPoint;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    final location = await ref.read(userLocationProvider.future);
    if (location == null || !mounted) return;

    _currentLocation = location;
    final filters = ref.read(partnerAdsFiltersProvider);
    if (filters.lat == null || filters.lng == null) {
      ref
          .read(partnerAdsFiltersProvider.notifier)
          .setLocation(location.latitude, location.longitude, 50);
    }
    _moveCameraTo(location);
  }

  Future<void> _handleRadiusSelected(double radius) async {
    final notifier = ref.read(partnerAdsFiltersProvider.notifier);
    if (radius == 0) {
      notifier.setLocation(null, null, 0);
      return;
    }

    var location = _currentLocation;
    location ??= await ref.read(userLocationProvider.future);
    if (location == null || !mounted) return;

    _currentLocation = location;
    notifier.setLocation(location.latitude, location.longitude, radius);
    _moveCameraTo(location);
  }

  Future<void> _moveCameraTo(LatLng location, {double zoom = 13}) async {
    final controller = _mapController;
    if (controller == null) return;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(location, zoom));
  }

  void _showPointOnMap(PartnerAdModel point) {
    final latitude = point.latitude;
    final longitude = point.longitude;
    if (latitude == null || longitude == null) return;

    setState(() => _selectedPoint = point);
    _moveCameraTo(LatLng(latitude, longitude), zoom: 15);
  }

  void _openPointDetails(PartnerAdModel point, AppLocalizations l10n) {
    final subtitle = point.partnerCompany ?? point.address;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CollectionPointsDetailsScreen(
          title: point.title,
          subtitle: subtitle,
          logoUrl: point.photoUrl ?? '',
          description: l10n.collectionPointDetailTemplate.replaceAll(
            '{subtitle}',
            subtitle,
          ),
          latitude: point.latitude,
          longitude: point.longitude,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pointsAsync = ref.watch(allCollectionPointsProvider);
    final filters = ref.watch(partnerAdsFiltersProvider);
    final filterNotifier = ref.read(partnerAdsFiltersProvider.notifier);

    ref.listen<PartnerAdsFilters>(partnerAdsFiltersProvider, (_, next) {
      if (next.lat != null && next.lng != null) {
        _moveCameraTo(LatLng(next.lat!, next.lng!));
      }
    });

    return AppBackgroundScaffold(
      showGridFromTop: true,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.collectionPoints, showUserAvatar: false),
            Expanded(
              child: pointsAsync.when(
                data: (points) => SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        child: Text(
                          l10n.collectionPointsFullDescription,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subtitle.copyWith(
                            color: _brandPrimary,
                            fontSize: 13,
                            height: 1.2,
                          ),
                        ),
                      ),
                      CollectionPointsMap(
                        points: points,
                        filters: filters,
                        currentLocation: _currentLocation,
                        selectedPoint: _selectedPoint,
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                        onMoveCamera: _moveCameraTo,
                        onPointSelected: (point) {
                          setState(() => _selectedPoint = point);
                        },
                        onOpenDetails: (point) =>
                            _openPointDetails(point, l10n),
                      ),
                      const SizedBox(height: 20),
                      CollectionPointFilters(
                        color: _brandPrimary,
                        filterNotifier: filterNotifier,
                        l10n: l10n,
                        onRadiusSelected: _handleRadiusSelected,
                      ),
                      const SizedBox(height: 20),
                      CollectionPointsList(
                        color: _brandPrimary,
                        cardBg: _cardBg,
                        points: points,
                        l10n: l10n,
                        onSeeOnMap: _showPointOnMap,
                        onOpenDetails: (point) =>
                            _openPointDetails(point, l10n),
                      ),
                      const SizedBox(height: 20),
                      CollectionPointsPagination(
                        color: _brandPrimary,
                        currentPage: filters.page,
                        filterNotifier: filterNotifier,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text('${l10n.error}: $err', style: AppTextStyles.body),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
