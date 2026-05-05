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
  static const double _collapsedFilterHeight = 55;

  final Map<String, BitmapDescriptor> _markerIconCache = {};
  final Set<String> _pendingMarkerIcons = {};
  GoogleMapController? _mapController;
  bool _filtersExpanded = false;
  bool _sortExpanded = false;
  bool _radiusExpanded = false;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = ref.watch(seekReportFiltersProvider);
    final statusList = (filters['status'] is List)
        ? List<String>.from(filters['status'])
        : (filters['status'] == 'all'
              ? <String>[]
              : [filters['status'].toString()]);
    final radius = filters['radius'] ?? 5;
    final sort = filters['sort']?.toString() ?? 'descending';
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
        const SizedBox(height: 60),
        Text(
          l10n.seekViewReports,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFBA4A22),
            fontSize: 28,
            fontFamily: 'EricaOne',
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 320,
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
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),
            Positioned(
              bottom: 45,
              right: 25,
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
          ],
        ),
        Transform.translate(
          offset: const Offset(0, -28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _buildInlineFilters(l10n, statusList),
          ),
        ),
        _buildSortAndRadiusControls(
          l10n: l10n,
          sort: sort,
          radius: (radius as num?)?.toInt() ?? 5,
          hasLocation: hasLocation,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSortAndRadiusControls({
    required AppLocalizations l10n,
    required String sort,
    required int radius,
    required bool hasLocation,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _sortExpanded = !_sortExpanded;
                      _radiusExpanded = false;
                    });
                  },
                  child: SeekFilterPill(
                    label: _sortLabel(l10n, sort).toUpperCase(),
                    icon: _sortExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _radiusExpanded = !_radiusExpanded;
                      _sortExpanded = false;
                    });
                  },
                  child: SeekFilterPill(
                    label: hasLocation
                        ? l10n.nearbyKm(radius)
                        : l10n.globalSearch,
                    icon: _radiusExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _sortExpanded
                ? _buildSortMenu(l10n, sort)
                : _radiusExpanded
                ? _buildRadiusMenu(radius)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSortMenu(AppLocalizations l10n, String currentSort) {
    return _FilterPanel(
      topPadding: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RadioOptionRow<String>(
            value: 'descending',
            groupValue: currentSort,
            label: l10n.sortByNewest,
            onChanged: _setDateSort,
          ),
          _RadioOptionRow<String>(
            value: 'ascending',
            groupValue: currentSort,
            label: l10n.sortByOldest,
            onChanged: _setDateSort,
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusMenu(int currentRadius) {
    const radiusOptions = [1, 5, 10, 25, 50];

    return _FilterPanel(
      topPadding: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: radiusOptions.map((radius) {
          return _RadioOptionRow<int>(
            value: radius,
            groupValue: currentRadius,
            label: '$radius km',
            onChanged: _setRadius,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInlineFilters(
    AppLocalizations l10n,
    List<String> currentStatuses,
  ) {
    final options = _statusFilterOptions(l10n);

    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: _collapsedFilterHeight),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_filtersExpanded ? 18 : 25),
          border: Border.all(color: const Color(0xFFF2E6D8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _filtersExpanded = !_filtersExpanded;
                });
              },
              borderRadius: BorderRadius.circular(35),
              child: SizedBox(
                height: _collapsedFilterHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.filters,
                      style: const TextStyle(
                        color: Color(0xFFBA4A22),
                        fontSize: 15,
                        fontFamily: 'EricaOne',
                      ),
                    ),
                    Icon(
                      _filtersExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFFBA4A22),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            if (_filtersExpanded) ...[
              const Divider(height: 1, color: Color(0xFFF2E6D8)),
              const SizedBox(height: 10),
              ...options.map((option) {
                final isSelected = currentStatuses.contains(option.value);
                return _FilterOptionRow(
                  label: option.label,
                  isSelected: isSelected,
                  onTap: () => _toggleStatus(option.value, currentStatuses),
                );
              }),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  List<_SeekStatusFilterOption> _statusFilterOptions(AppLocalizations l10n) {
    return [
      _SeekStatusFilterOption('lost', l10n.filterLostAnimals),
      _SeekStatusFilterOption('found', l10n.filterFoundAnimals),
      _SeekStatusFilterOption('sighted', l10n.filterSightedAnimals),
      _SeekStatusFilterOption('rescued', l10n.filterInjuredAnimals),
    ];
  }

  void _toggleStatus(String status, List<String> currentStatuses) {
    final currentFilters = ref.read(seekReportFiltersProvider);
    final nextStatuses = List<String>.from(currentStatuses);

    if (nextStatuses.contains(status)) {
      nextStatuses.remove(status);
    } else {
      nextStatuses.add(status);
    }

    ref.read(seekReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'status': nextStatuses,
      'page': 1,
    };
  }

  void _setDateSort(String sort) {
    final currentFilters = ref.read(seekReportFiltersProvider);
    ref.read(seekReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'sortBy': 'date',
      'sort': sort,
      'page': 1,
    };
    setState(() {
      _sortExpanded = false;
    });
  }

  void _setRadius(int radius) {
    final currentFilters = ref.read(seekReportFiltersProvider);
    final updatedFilters = {...currentFilters, 'radius': radius, 'page': 1};

    if (!updatedFilters.containsKey('lat') && widget.currentLocation != null) {
      updatedFilters['lat'] = widget.currentLocation!.latitude;
      updatedFilters['lng'] = widget.currentLocation!.longitude;
    }

    ref.read(seekReportFiltersProvider.notifier).state = updatedFilters;
    setState(() {
      _radiusExpanded = false;
    });
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'lost':
        return l10n.statusMissing;
      case 'found':
        return l10n.statusFound;
      case 'sighted':
        return l10n.filterSightedAnimals;
      case 'rescued':
        return l10n.statusRescued;
      case 'all':
      default:
        return l10n.statusAll;
    }
  }

  String _sortLabel(AppLocalizations l10n, String sort) {
    return sort == 'ascending' ? l10n.sortByOldest : l10n.sortByNewest;
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

class _SeekStatusFilterOption {
  const _SeekStatusFilterOption(this.value, this.label);

  final String value;
  final String label;
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({required this.child, this.topPadding = 0});

  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF2E6D8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _RadioOptionRow<T> extends StatelessWidget {
  const _RadioOptionRow({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 34,
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: (next) {
                if (next != null) onChanged(next);
              },
              activeColor: const Color(0xFFBA4A22),
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFFBA4A22),
                  fontSize: 15,
                  fontFamily: 'EricaOne',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterOptionRow extends StatelessWidget {
  const _FilterOptionRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 28,
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFBA4A22) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
              ),
              child: Icon(
                isSelected ? Icons.check_rounded : Icons.close_rounded,
                color: isSelected ? Colors.white : const Color(0xFFBA4A22),
                size: 13,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontSize: 12,
                  fontFamily: 'EricaOne',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
