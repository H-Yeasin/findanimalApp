import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'animal_profile_data.dart';
import '../../providers/seek_report_detail_provider.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class AnimalProfileMapSection extends ConsumerStatefulWidget {
  final AnimalProfileData data;

  const AnimalProfileMapSection({super.key, required this.data});

  @override
  ConsumerState<AnimalProfileMapSection> createState() =>
      _AnimalProfileMapSectionState();
}

class _AnimalProfileMapSectionState
    extends ConsumerState<AnimalProfileMapSection> {
  BitmapDescriptor? _customMarker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_customMarker == null) {
      _loadCustomMarker(MediaQuery.of(context).devicePixelRatio);
    }
  }

  Future<void> _loadCustomMarker(double pixelRatio) async {
    final marker = await BitmapDescriptor.asset(
      ImageConfiguration(
        devicePixelRatio: pixelRatio,
        size: const Size(32, 38), // Updated height and width here
      ),
      AppAssets.animalMapPin,
    );
    if (mounted) {
      setState(() {
        _customMarker = marker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reportAsync = ref.watch(seekReportDetailProvider(widget.data.id));
    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScaler = MediaQuery.textScalerOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : screenWidth;
        final buttonMaxWidth = (availableWidth - 32).clamp(180.0, 360.0);
        final shouldWrapButtonLabel = textScaler.scale(1) > 1.2;

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
                          icon:
                              _customMarker ??
                              BitmapDescriptor.defaultMarkerWithHue(
                                report.status.toLowerCase() == 'found'
                                    ? BitmapDescriptor.hueOrange
                                    : BitmapDescriptor.hueGreen,
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
              left: 16,
              right: 16,
              bottom: -20,
              child: Center(
                child: GestureDetector(
                  onTap: () => _openMap(context),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFBA4A22),
                          width: 1.0,
                        ),
                      ),
                      child: shouldWrapButtonLabel
                          ? Text(
                              l10n.viewOnMapLastLocation,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.brandPrimary,
                                fontSize: _responsiveFont(context, 12),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                                height: 1.1,
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                l10n.viewOnMapLastLocation,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.brandPrimary,
                                  fontSize: _responsiveFont(context, 12),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                  height: 1.1,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _responsiveFont(BuildContext context, double size) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 360) return size * 0.85;
    if (width < 400) return size * 0.92;
    return size;
  }

  Future<void> _openMap(BuildContext context) async {
    final lat = widget.data.latitude;
    final lng = widget.data.longitude;
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
          height: 200,
          fit: BoxFit.cover,
          color: Colors.white.withValues(alpha: 0.3),
          colorBlendMode: BlendMode.screen,
        ),
        const Positioned(left: 40, top: 30, child: _MapPin(icon: Icons.pets)),
        // const Positioned(
        //   right: 50,
        //   bottom: 45,
        //   child: _MapPin(icon: Icons.add),
        // ),
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
          const Icon(
            Icons.location_on,
            color: Color.fromARGB(255, 228, 222, 220),
            size: 48,
          ),
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
