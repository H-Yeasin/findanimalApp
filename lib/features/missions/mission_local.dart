import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/providers/location_provider.dart';
import '../partner/presentation/widgets/partner_ui_kit.dart';
import 'data/models/mission_model.dart';
import 'presentation/providers/missions_filters_provider.dart';
import 'presentation/providers/missions_list_provider.dart';
import 'presentation/widgets/local_mission_card.dart';
import 'presentation/widgets/local_mission_filter_bar.dart';
import 'presentation/widgets/local_mission_header.dart';
import 'presentation/widgets/local_mission_map_section.dart';
import 'presentation/widgets/local_mission_pagination.dart';
import 'presentation/widgets/missions_filters_bottom_sheet.dart';

class MissionLocalScreen extends ConsumerStatefulWidget {
  const MissionLocalScreen({super.key});

  @override
  ConsumerState<MissionLocalScreen> createState() => _MissionLocalScreenState();
}

class _MissionLocalScreenState extends ConsumerState<MissionLocalScreen> {
  static const double _nearbyRadiusKm = 50;
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(48.8566, 2.3522);
  BitmapDescriptor? _customPin;
  MissionModel? _selectedMission;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCustomPin();
    _initializeLocation();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomPin() async {
    _customPin = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 50)),
      AppAssets.missionMapPin,
    );
    if (mounted) setState(() {});
  }

  Future<void> _initializeLocation() async {
    final location = await ref.read(userLocationProvider.future);
    if (location == null || !mounted) return;

    setState(() => _currentPosition = location);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 13));
  }

  Future<void> _handleLocateMe() async {
    ref.invalidate(userLocationProvider);
    final location = await ref.read(userLocationProvider.future);
    if (!mounted) return;

    if (location == null) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.couldNotGetLocation)));
      return;
    }

    _setMissionLocation(location, zoom: 14);
  }

  void _setMissionLocation(LatLng location, {required double zoom}) {
    setState(() => _currentPosition = location);

    final currentFilters = ref.read(missionsFiltersProvider);
    ref.read(missionsFiltersProvider.notifier).state = {
      ...currentFilters,
      'lat': location.latitude,
      'lng': location.longitude,
      'radius': _nearbyRadiusKm,
      'page': 1,
    };

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, zoom));
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: PartnerUiColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const MissionsFiltersBottomSheet(),
    );
  }

  Set<Marker> _buildMarkers(List<MissionModel> missions) {
    final markers = <Marker>{};

    for (final mission in missions) {
      final lat = mission.location?.latitude;
      final lng = mission.location?.longitude;
      if (lat == null || lng == null) continue;

      markers.add(
        Marker(
          markerId: MarkerId('mission_${mission.id}'),
          position: LatLng(lat, lng),
          onTap: () {
            setState(() {
              if (_selectedMission?.id == mission.id) {
                _selectedMission = null;
              } else {
                _selectedMission = mission;
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14),
                );
              }
            });
          },
          icon:
              _customPin ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }

    return markers;
  }

  Set<Circle> _buildCircles(LatLng center, double? radiusKm) {
    if (radiusKm == null) return {};
    return {
      Circle(
        circleId: const CircleId('mission_radius'),
        center: center,
        radius: radiusKm * 1000,
        fillColor: PartnerUiColors.brand.withValues(alpha: 0.1),
        strokeColor: PartnerUiColors.brand.withValues(alpha: 0.4),
        strokeWidth: 2,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final missionsAsync = ref.watch(missionsListProvider);
    final missionsForMap = missionsAsync.valueOrNull?.data ?? const [];
    final filters = ref.watch(missionsFiltersProvider);
    final l10n = AppLocalizations.of(context);

    final center = (filters['lat'] != null && filters['lng'] != null)
        ? LatLng(filters['lat'] as double, filters['lng'] as double)
        : _currentPosition;

    return PartnerScreenScaffold(
      bottomNavIndex: 0,
      scrollController: _scrollController,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LocalMissionHeader(
              title: l10n.seeLocalMissions,
              description: l10n.missionsLocalesDescription,
            ),
            const SizedBox(height: 18),
            LocalMissionMapSection(
              currentPosition: center,
              markers: _buildMarkers(missionsForMap),
              onMapCreated: (controller) => _mapController = controller,
              onLocateMe: _handleLocateMe,
              onTapMap: () {
                if (_selectedMission != null) {
                  setState(() => _selectedMission = null);
                }
              },
              selectedMission: _selectedMission,
              circles: _buildCircles(
                center,
                (filters['radius'] as num?)?.toDouble(),
              ),
            ),
            const SizedBox(height: 14),
            LocalMissionFilterBar(
              radiusText: filters['radius'] == null
                  ? l10n.searchRadius
                  : l10n.radiusKm.replaceAll(
                      '{radius}',
                      filters['radius'].toString(),
                    ),
              sortText: filters['sortBy'] == null
                  ? l10n.sortBy
                  : '${l10n.sortBy}: ${filters['sortBy']}',
              onOpenFilters: _showFiltersBottomSheet,
            ),
            const SizedBox(height: 18),
            missionsAsync.when(
              data: (paginatedData) {
                final missions = paginatedData.data;
                if (missions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Text(
                      l10n.noMissionsFound,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: PartnerUiColors.brand,
                        fontFamily: 'EricaOne',
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    for (final mission in missions)
                      LocalMissionCard(
                        mission,
                        onSeeOnMap: () {
                          final lat = mission.location?.latitude;
                          final lng = mission.location?.longitude;
                          if (lat != null && lng != null) {
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              _selectedMission = mission;
                            });
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
                            );
                          }
                        },
                      ),
                    LocalMissionPagination(
                      page: paginatedData.page,
                      totalPages: paginatedData.totalPages,
                      onPageSelected: (page) => ref
                          .read(missionsListProvider.notifier)
                          .goToPage(page),
                    ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(
                    color: PartnerUiColors.brand,
                  ),
                ),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  '${l10n.error}: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
