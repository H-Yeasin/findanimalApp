import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../Collection_Point/collection_point.dart';
import '../../../Collection_Point/collections_points_details.dart';
import '../../../Collection_Point/widgets/collection_points_map.dart';
import '../../../partner_ads/data/models/partner_ad_model.dart';
import '../../../partner_ads/presentation/providers/partner_ads_filters_provider.dart';
import '../../../partner_ads/presentation/providers/partner_collection_points_provider.dart';

class HubCollectionPointsSection extends ConsumerStatefulWidget {
  final AppLocalizations l10n;

  const HubCollectionPointsSection({super.key, required this.l10n});

  @override
  ConsumerState<HubCollectionPointsSection> createState() =>
      _HubCollectionPointsSectionState();
}

class _HubCollectionPointsSectionState
    extends ConsumerState<HubCollectionPointsSection> {
  GoogleMapController? _mapController;
  PartnerAdModel? _selectedPoint;

  Future<void> _moveCameraTo(LatLng location, {double zoom = 13}) async {
    final controller = _mapController;
    if (controller == null) return;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(location, zoom));
  }

  void _openPointDetails(PartnerAdModel point) {
    final subtitle = point.partnerCompany ?? point.address;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CollectionPointsDetailsScreen(
          title: point.title,
          subtitle: subtitle,
          logoUrl: point.photoUrl ?? '',
          description: widget.l10n.collectionPointDetailTemplate.replaceAll(
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
    const brandPrimary = Color(0xFFBA4A22);
    final l10n = widget.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Text(
          l10n.collectionPoints.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.condensedSectionTitle.copyWith(
            fontSize: 27,
          ),
        ),
        Text(
          l10n.collectionPointsAround,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            fontSize: 14,
            height: 1,
          ),
        ),
        const SizedBox(height: 15),
        ref.watch(allCollectionPointsProvider).when(
              data: (points) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    CollectionPointsMap(
                      points: points,
                      filters: PartnerAdsFilters(),
                      currentLocation: null,
                      selectedPoint: _selectedPoint,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      onMoveCamera: _moveCameraTo,
                      onPointSelected: (point) {
                        setState(() => _selectedPoint = point);
                      },
                      onOpenDetails: _openPointDetails,
                    ),
                    Positioned(
                      bottom: -20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CollectionPointScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF4E9),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: brandPrimary.withValues(
                                alpha: 0.5,
                              ),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            l10n.homeSeeMore.toUpperCase(),
                            style: const TextStyle(
                              color: brandPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox(
                height: 300,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SizedBox(
                height: 300,
                width: double.infinity,
                child: Center(
                  child: Text('Error loading map: $err'),
                ),
              ),
            ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: l10n.collectionPointsDescription),
                TextSpan(
                  text: l10n.donatingNearYou,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: brandPrimary,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
