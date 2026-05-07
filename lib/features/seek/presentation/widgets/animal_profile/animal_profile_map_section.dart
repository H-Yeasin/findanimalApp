import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'animal_profile_data.dart';
import '../../providers/seek_report_detail_provider.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class AnimalProfileMapSection extends ConsumerWidget {
  final AnimalProfileData data;

  const AnimalProfileMapSection({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reportAsync = ref.watch(seekReportDetailProvider(data.id));

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Map area
        Container(
          height: 190,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFBA4A22), width: 1.5),
              bottom: BorderSide(color: Color(0xFFBA4A22), width: 1.5),
            ),
          ),
          child: reportAsync.when(
            data: (report) {
              if (report.location.coordinates.length >= 2) {
                final lat = report.location.coordinates[1];
                final lng = report.location.coordinates[0];
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(report.id),
                      position: LatLng(lat, lng),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        report.status.toLowerCase() == 'found'
                            ? BitmapDescriptor.hueAzure
                            : BitmapDescriptor.hueOrange,
                      ),
                    ),
                  },
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: false,
                );
              }
              return const _StaticMapPlaceholder();
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
            ),
            error: (err, stack) => const _StaticMapPlaceholder(),
          ),
        ),
        // VIEW ON MAP button
        Positioned(
          left: 0,
          right: 0,
          bottom: -16,
          child: Center(
            child: GestureDetector(
              onTap: () => _openMap(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFBA4A22),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  l10n.viewOnMapLastLocation,
                  style: AppTextStyles.body.copyWith(
                    color: Color(0xFFBA4A22),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'EricaOne',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openMap(BuildContext context) async {
    final lat = data.latitude;
    final lng = data.longitude;
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).noLocationAvailable),
        ),
      );
      return;
    }

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).couldNotOpenMap)),
      );
    }
  }
}

class _StaticMapPlaceholder extends StatelessWidget {
  const _StaticMapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppAssets.animalMapPin,
          width: double.infinity,
          height: 190,
          fit: BoxFit.cover,
          color: Colors.white.withValues(alpha: 0.3),
          colorBlendMode: BlendMode.screen,
        ),
        const Positioned(left: 40, top: 30, child: _MapPin(icon: Icons.pets)),
        const Positioned(
          right: 50,
          bottom: 45,
          child: _MapPin(icon: Icons.add),
        ),
      ],
    );
  }
}

class _MapPin extends StatelessWidget {
  final IconData icon;

  const _MapPin({required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 50,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Icon(Icons.location_on, color: Color(0xFFBA4A22), size: 48),
          Positioned(
            top: 6,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFBA4A22),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 13),
            ),
          ),
        ],
      ),
    );
  }
}
