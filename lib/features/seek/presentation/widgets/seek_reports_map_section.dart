import 'package:hesteka_frontend/core/config/app_assets.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../data/models/report_model.dart';
import '../providers/seek_report_filters_provider.dart';
import '../providers/seek_reports_provider.dart';
import 'report_map_card.dart';
import 'seek_filter_pill.dart';
import 'seek_reports_map_filters.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

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

  GoogleMapController? _mapController;
  bool _filtersExpanded = false;
  bool _sortExpanded = false;
  bool _radiusExpanded = false;
  BitmapDescriptor? _customPin;

  @override
  void initState() {
    super.initState();
    _loadCustomPin();
  }

  Future<void> _loadCustomPin() async {
    _customPin = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 50)),
      AppAssets.animalMapPin,
    );
    if (mounted) setState(() {});
  }

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

    ref.listen<ReportModel?>(selectedSeekReportProvider, (_, next) {
      if (next != null && next.location.coordinates.length >= 2) {
        _animateToLocation(
          LatLng(next.location.coordinates[1], next.location.coordinates[0]),
          zoom: 14,
        );
        // Optionally, one could scroll to top here using PrimaryScrollController
        final primaryScrollController = PrimaryScrollController.maybeOf(context);
        if (primaryScrollController != null && primaryScrollController.hasClients) {
          primaryScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });

    final selectedReport = ref.watch(selectedSeekReportProvider);

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
              onTap: () {
                final currentSelected = ref.read(selectedSeekReportProvider);
                if (currentSelected?.id == report.id) {
                  ref.read(selectedSeekReportProvider.notifier).state = null;
                } else {
                  ref.read(selectedSeekReportProvider.notifier).state = report;
                }
              },
              icon: _customPin ??
                  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
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
          style: AppTextStyles.body.copyWith(
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
                onTap: (_) {
                  if (selectedReport != null) {
                    ref.read(selectedSeekReportProvider.notifier).state = null;
                  }
                },
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
            if (selectedReport != null)
              Positioned(
                top: 15,
                left: 16,
                child: ReportMapCard(
                  report: selectedReport,
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
                // flex: 2,
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
    return SeekFilterPanel(
      topPadding: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SeekRadioOptionRow<String>(
            value: 'descending',
            groupValue: currentSort,
            label: l10n.sortByNewest,
            onChanged: _setDateSort,
          ),
          SeekRadioOptionRow<String>(
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

    return SeekFilterPanel(
      topPadding: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: radiusOptions.map((radius) {
          return SeekRadioOptionRow<int>(
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
                      style: AppTextStyles.body.copyWith(
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
                return SeekFilterOptionRow(
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

  List<SeekStatusFilterOption> _statusFilterOptions(AppLocalizations l10n) {
    return [
      SeekStatusFilterOption('lost', l10n.filterLostAnimals),
      SeekStatusFilterOption('found', l10n.filterFoundAnimals),
      SeekStatusFilterOption('sighted', l10n.filterSightedAnimals),
      SeekStatusFilterOption('rescued', l10n.filterInjuredAnimals),
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

  String _sortLabel(AppLocalizations l10n, String sort) {
    return sort == 'ascending' ? l10n.sortByOldest : l10n.sortByNewest;
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
}

