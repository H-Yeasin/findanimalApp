import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../Collection_Point/collection_point.dart';
import '../../../partner_ads/presentation/providers/partner_collection_points_provider.dart';

class HubCollectionPointsSection extends ConsumerWidget {
  final AppLocalizations l10n;

  const HubCollectionPointsSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const brandPrimary = Color(0xFFBA4A22);

    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          l10n.collectionPoints.toUpperCase(),
          style: AppTextStyles.condensedSectionTitle.copyWith(
            fontSize: 27,
          ),
        ),
        Text(
          l10n.collectionPointsAround,
          style: AppTextStyles.caption.copyWith(
            fontSize: 14,
            height: 1,
          ),
        ),
        const SizedBox(height: 15),
        ref.watch(allCollectionPointsProvider).when(
              data: (points) {
                final markers = points
                    .where(
                      (p) => p.latitude != null && p.longitude != null,
                    )
                    .map(
                      (p) => Marker(
                        markerId: MarkerId(p.id),
                        position: LatLng(p.latitude!, p.longitude!),
                        infoWindow: InfoWindow(
                          title: p.title,
                          snippet: p.address,
                        ),
                      ),
                    )
                    .toSet();

                return Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 280,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: brandPrimary.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: markers.isNotEmpty
                                ? markers.first.position
                                : const LatLng(0, 0),
                            zoom: 14.0,
                          ),
                          markers: markers,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                        ),
                      ),
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
                height: 280,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Container(
                height: 280,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey.withValues(alpha: 0.1),
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
