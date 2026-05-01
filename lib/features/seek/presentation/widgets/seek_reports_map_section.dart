import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/seek_report_filters_provider.dart';
import '../providers/seek_reports_provider.dart';
import 'seek_filter_pill.dart';

class SeekReportsMapSection extends ConsumerStatefulWidget {
  const SeekReportsMapSection({
    required this.currentLocation,
    required this.onLocateMe,
    required this.onShowFilters,
    super.key,
  });

  final LatLng? currentLocation;
  final VoidCallback onLocateMe;
  final ValueChanged<String> onShowFilters;

  @override
  ConsumerState<SeekReportsMapSection> createState() =>
      _SeekReportsMapSectionState();
}

class _SeekReportsMapSectionState extends ConsumerState<SeekReportsMapSection> {
  final Map<String, BitmapDescriptor> _markerIconCache = {};
  final Set<String> _pendingMarkerIcons = {};
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = ref.watch(seekReportFiltersProvider);
    final status = filters['status'] ?? 'all';
    final radius = filters['radius'] ?? 5;
    final hasLocation = filters.containsKey('lat');
    final reportsAsync = ref.watch(seekReportsProvider);
    final mapTarget =
        _locationFromFilters(filters) ??
        widget.currentLocation ??
        const LatLng(0, 0);

    ref.listen<Map<String, dynamic>>(seekReportFiltersProvider, (_, next) {
      final nextLocation = _locationFromFilters(next);
      if (nextLocation != null) {
        _animateToLocation(nextLocation);
      }
    });

    final markers = <Marker>{};
    if (reportsAsync.hasValue) {
      for (final report in reportsAsync.value!.data) {
        if (report.location.coordinates.length >= 2) {
          markers.add(
            Marker(
              markerId: MarkerId(report.id),
              position: LatLng(
                report.location.coordinates[1],
                report.location.coordinates[0],
              ),
              infoWindow: InfoWindow(
                title: report.animalName.toUpperCase(),
                snippet: '${report.status} | ${report.breed}',
              ),
              icon: _markerIconFor(
                report.species,
                report.status,
                MediaQuery.devicePixelRatioOf(context),
              ),
              anchor: const Offset(0.5, 0.95),
            ),
          );
        }
      }
    }

    final circles = <Circle>{};
    if (hasLocation) {
      final lat = (filters['lat'] as num?)?.toDouble();
      final lng = (filters['lng'] as num?)?.toDouble();
      final radiusKm = (radius as num?)?.toDouble() ?? 5;
      if (lat != null && lng != null) {
        circles.add(
          Circle(
            circleId: const CircleId('active-search-radius'),
            center: LatLng(lat, lng),
            radius: radiusKm * 1000,
            strokeWidth: 2,
            strokeColor: const Color(0xFFBA4A22),
            fillColor: const Color(0xFFBA4A22).withValues(alpha: 0.06),
          ),
        );
      }
    }

    return Column(
      children: [
        const SizedBox(height: 70),
        Text(
          l10n.seekViewReports,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFBA4A22),
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontFamily: 'EricaOne',
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF2E6D8), width: 1),
                ),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: mapTarget,
                  zoom: hasLocation ? 12 : 2,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  final currentTarget =
                      _locationFromFilters(
                        ref.read(seekReportFiltersProvider),
                      ) ??
                      widget.currentLocation;
                  if (currentTarget != null) {
                    _animateToLocation(currentTarget, zoom: 12);
                  }
                },
                markers: markers,
                circles: circles,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),
            Positioned(
              top: 15,
              right: 20,
              child: GestureDetector(
                onTap: widget.onLocateMe,
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
                    size: 22,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -28,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () => widget.onShowFilters('all'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: const Color(0xFFF2E6D8),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.filters,
                        style: const TextStyle(
                          color: Color(0xFFBA4A22),
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          fontFamily: 'EricaOne',
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFFBA4A22),
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 45),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onShowFilters('sort'),
                  child: SeekFilterPill(
                    label: status.toString().toUpperCase(),
                    icon: Icons.keyboard_arrow_down,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => widget.onShowFilters('location'),
                  child: SeekFilterPill(
                    label: hasLocation
                        ? l10n.nearbyKm(radius)
                        : l10n.globalSearch,
                    icon: Icons.keyboard_arrow_down,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  BitmapDescriptor _markerIconFor(
    String species,
    String status,
    double devicePixelRatio,
  ) {
    final key = '${species.toLowerCase()}-${status.toLowerCase()}';
    final cached = _markerIconCache[key];
    if (cached != null) return cached;

    if (!_pendingMarkerIcons.contains(key)) {
      _pendingMarkerIcons.add(key);
      _createAnimalMarkerIcon(
        species: species,
        status: status,
        devicePixelRatio: devicePixelRatio,
      ).then((icon) {
        if (!mounted) return;
        setState(() {
          _markerIconCache[key] = icon;
          _pendingMarkerIcons.remove(key);
        });
      });
    }

    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  }

  LatLng? _locationFromFilters(Map<String, dynamic> filters) {
    final lat = (filters['lat'] as num?)?.toDouble();
    final lng = (filters['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  Future<void> _animateToLocation(LatLng location, {double zoom = 12}) async {
    final controller = _mapController;
    if (controller == null) return;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: zoom),
      ),
    );
  }

  Future<BitmapDescriptor> _createAnimalMarkerIcon({
    required String species,
    required String status,
    required double devicePixelRatio,
  }) async {
    final logicalSize = const Size(44, 54);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final scale = devicePixelRatio.clamp(1.0, 3.0);
    canvas.scale(scale);

    const brand = Color(0xFFBA4A22);
    const white = Colors.white;
    final paint = Paint()..isAntiAlias = true;
    final path = Path()
      ..addOval(const Rect.fromLTWH(7, 1, 30, 30))
      ..moveTo(22, 52)
      ..cubicTo(14, 39, 9, 30, 9, 21)
      ..cubicTo(9, 9, 15, 2, 22, 2)
      ..cubicTo(29, 2, 35, 9, 35, 21)
      ..cubicTo(35, 30, 30, 39, 22, 52)
      ..close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.25), 3, true);
    paint.color = brand;
    canvas.drawPath(path, paint);

    final innerPaint = Paint()
      ..color = white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(const Offset(22, 21), 9, innerPaint);

    final icon = _iconFor(species: species, status: status);
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: white,
          fontSize: 18,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(22 - iconPainter.width / 2, 21 - iconPainter.height / 2),
    );

    final statusDot = Paint()..color = _statusAccent(status);
    canvas.drawCircle(const Offset(32, 9), 5, Paint()..color = white);
    canvas.drawCircle(const Offset(32, 9), 3.5, statusDot);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (logicalSize.width * scale).round(),
      (logicalSize.height * scale).round(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(
      Uint8List.view(bytes!.buffer),
      imagePixelRatio: scale,
      width: logicalSize.width,
      height: logicalSize.height,
    );
  }

  IconData _iconFor({required String species, required String status}) {
    final normalizedStatus = status.toLowerCase();
    if (normalizedStatus == 'lost') return Icons.priority_high_rounded;
    if (normalizedStatus == 'rescued') return Icons.add_rounded;

    switch (species.toLowerCase()) {
      case 'bird':
        return Icons.flutter_dash_rounded;
      case 'cat':
      case 'dog':
      default:
        return Icons.pets_rounded;
    }
  }

  Color _statusAccent(String status) {
    switch (status.toLowerCase()) {
      case 'found':
        return const Color(0xFFFFE4B8);
      case 'rescued':
        return const Color(0xFFEBD6B5);
      case 'sighted':
        return const Color(0xFFFFF1D0);
      case 'lost':
      default:
        return const Color(0xFFFFFFFF);
    }
  }
}
