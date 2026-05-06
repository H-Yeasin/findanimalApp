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

  @override
  void initState() {
    super.initState();
    _loadCustomPin();
    _initializeLocation();
  }

  Future<void> _loadCustomPin() async {
    _customPin = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 50)),
      'assets/images/Map/mission_pin.png',
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
              _selectedMission = mission;
            });
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14),
            );
          },
          icon:
              _customPin ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final missionsAsync = ref.watch(missionsListProvider);
    final missionsForMap = missionsAsync.valueOrNull?.data ?? const [];
    final filters = ref.watch(missionsFiltersProvider);
    final l10n = AppLocalizations.of(context);

    return PartnerScreenScaffold(
      bottomNavIndex: 0,
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
              currentPosition: _currentPosition,
              markers: _buildMarkers(missionsForMap),
              onMapCreated: (controller) => _mapController = controller,
              onLocateMe: _handleLocateMe,
              onTapMap: () {
                if (_selectedMission != null) {
                  setState(() => _selectedMission = null);
                }
              },
              selectedMission: _selectedMission,
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
                    for (final mission in missions) LocalMissionCard(mission),
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
