import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/home_providers.dart';

class HomeMapSection extends ConsumerWidget {
  const HomeMapSection({
    super.key,
    required this.onLocateMe,
    required this.onExploreFullMap,
  });

  final VoidCallback onLocateMe;
  final VoidCallback onExploreFullMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reportsAsync = ref.watch(homeReportsProvider);
    const initialLocation = LatLng(48.8566, 2.3522);

    final markers = <Marker>{};
    if (reportsAsync.hasValue) {
      for (final report in reportsAsync.value!) {
        if (report.location.coordinates.length >= 2) {
          markers.add(
            Marker(
              markerId: MarkerId('home_${report.id}'),
              position: LatLng(
                report.location.coordinates[1],
                report.location.coordinates[0],
              ),
              infoWindow: InfoWindow(
                title: report.animalName.toUpperCase(),
                snippet: '${report.status} | ${report.breed}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                report.status.toLowerCase() == 'found'
                    ? BitmapDescriptor.hueAzure
                    : BitmapDescriptor.hueOrange,
              ),
            ),
          );
        }
      }
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            border: const Border.symmetric(
              horizontal: BorderSide(color: Color(0xFFF2E6D8), width: 2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRect(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: initialLocation,
                zoom: 11,
              ),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
        ),
        Positioned(
          top: 15,
          right: 16,
          child: GestureDetector(
            onTap: onLocateMe,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.my_location,
                color: Color(0xFFBA4A22),
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -15,
          child: GestureDetector(
            onTap: onExploreFullMap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFBA4A22),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFBA4A22).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                l10n.homeExploreFullMap,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  fontFamily: 'BarlowCondensed',
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
