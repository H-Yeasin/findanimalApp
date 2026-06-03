import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/partner_ads/data/models/partner_ad_model.dart';
import 'package:hesteka_frontend/features/partner_ads/presentation/providers/partner_ads_filters_provider.dart';

typedef MoveCameraCallback = Future<void> Function(
  LatLng location, {
  double zoom,
});

class CollectionPointsMap extends StatefulWidget {
  const CollectionPointsMap({
    super.key,
    required this.points,
    required this.filters,
    required this.currentLocation,
    required this.selectedPoint,
    required this.myLocationEnabled,
    required this.onMapCreated,
    required this.onMoveCamera,
    required this.onPointSelected,
    required this.onOpenDetails,
  });

  final List<PartnerAdModel> points;
  final PartnerAdsFilters filters;
  final LatLng? currentLocation;
  final PartnerAdModel? selectedPoint;
  final bool myLocationEnabled;
  final ValueChanged<GoogleMapController> onMapCreated;
  final MoveCameraCallback onMoveCamera;
  final ValueChanged<PartnerAdModel?> onPointSelected;
  final ValueChanged<PartnerAdModel> onOpenDetails;

  @override
  State<CollectionPointsMap> createState() => _CollectionPointsMapState();
}

class _CollectionPointsMapState extends State<CollectionPointsMap> {
  BitmapDescriptor? _customPin;

  @override
  void initState() {
    super.initState();
    _loadCustomPin();
  }

  Future<void> _loadCustomPin() async {
    _customPin = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 50)),
      AppAssets.collectionPointMapPin,
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final markers = widget.points
        .where((point) => point.latitude != null && point.longitude != null)
        .map(
          (point) => Marker(
            markerId: MarkerId('collection_point_${point.id}'),
            position: LatLng(point.latitude!, point.longitude!),
            onTap: () => _handleMarkerTap(point),
            icon:
                _customPin ??
                BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange,
                ),
            anchor: const Offset(0.5, 0.95),
          ),
        )
        .toSet();
    final filterLocation =
        widget.filters.lat != null && widget.filters.lng != null
        ? LatLng(widget.filters.lat!, widget.filters.lng!)
        : null;
    final mapTarget =
        filterLocation ??
        widget.currentLocation ??
        (markers.isNotEmpty
            ? markers.first.position
            : const LatLng(48.8566, 2.3522));

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: (controller) {
                widget.onMapCreated(controller);
                widget.onMoveCamera(mapTarget);
              },
              onTap: (_) => widget.onPointSelected(null),
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: mapTarget,
                zoom: 13,
              ),
              markers: markers,
              myLocationEnabled: widget.myLocationEnabled,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
          if (widget.selectedPoint != null)
            Positioned(
              top: 15,
              left: 16,
              child: _CollectionPointMapCard(
                point: widget.selectedPoint!,
                onOpenDetails: () =>
                    widget.onOpenDetails(widget.selectedPoint!),
              ),
            ),
        ],
      ),
    );
  }

  void _handleMarkerTap(PartnerAdModel point) {
    final latitude = point.latitude;
    final longitude = point.longitude;
    if (latitude == null || longitude == null) return;

    if (widget.selectedPoint?.id == point.id) {
      widget.onPointSelected(null);
      return;
    }

    widget.onPointSelected(point);
    widget.onMoveCamera(LatLng(latitude, longitude), zoom: 14);
  }
}

class _CollectionPointMapCard extends StatelessWidget {
  const _CollectionPointMapCard({
    required this.point,
    required this.onOpenDetails,
  });

  final PartnerAdModel point;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subtitle = point.partnerCompany ?? point.address;
    final logoUrl = point.photoUrl ?? '';

    return Container(
      width: 124,
      height: 74,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.brandPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: logoUrl.startsWith('http')
                        ? Image.network(
                            logoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.store,
                                  color: AppColors.brandPrimary,
                                  size: 18,
                                ),
                          )
                        : const Icon(
                            Icons.store,
                            color: AppColors.brandPrimary,
                            size: 18,
                          ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        point.title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.heading.copyWith(
                          color: Colors.white,
                          fontSize: 9,
                          height: 1,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontSize: 6,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onOpenDetails,
            child: Container(
              height: 18,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF4E9),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                l10n.seeCollectionPoint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.button.copyWith(
                  color: AppColors.brandPrimary,
                  fontSize: 7,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
