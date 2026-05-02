import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/seek_report_filters_provider.dart';
import '../widgets/seek_reports_filter_sheet.dart';
import '../widgets/seek_reports_list.dart';
import '../widgets/seek_reports_map_section.dart';
import '../widgets/seek_reports_pagination.dart';

class SeekReportsScreen extends ConsumerStatefulWidget {
  const SeekReportsScreen({super.key});

  @override
  ConsumerState<SeekReportsScreen> createState() => _SeekReportsScreenState();
}

class _SeekReportsScreenState extends ConsumerState<SeekReportsScreen> {
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    final position = await _getCurrentPosition(requestIfNeeded: false);
    if (position == null || !mounted) return;
    _updateLocationFilters(position.latitude, position.longitude);
  }

  Future<Position?> _getCurrentPosition({required bool requestIfNeeded}) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        if (!requestIfNeeded) return null;
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      return Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('Error initializing location: $e');
      return null;
    }
  }

  Future<void> _handleLocateMe() async {
    final l10n = AppLocalizations.of(context);
    final position = await _getCurrentPosition(requestIfNeeded: true);
    if (!mounted) return;

    if (position == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.couldNotGetLocation)));
      return;
    }

    _updateLocationFilters(position.latitude, position.longitude);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.locationUpdated)));
  }

  void _updateLocationFilters(double lat, double lng) {
    if (!mounted) return;
    setState(() {
      _currentLocation = LatLng(lat, lng);
    });
    final currentFilters = ref.read(seekReportFiltersProvider);
    ref.read(seekReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'lat': lat,
      'lng': lng,
      'radius': 10,
      'page': 1,
    };
  }

  void _showFiltersBottomSheet(String initialSection) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return SeekReportsFilterSheet(initialSection: initialSection);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppBackgroundColors.paper,
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground(child: SizedBox.expand())),
          SingleChildScrollView(
            child: Column(
              children: [
                SeekReportsMapSection(
                  currentLocation: _currentLocation,
                  onLocateMe: _handleLocateMe,
                  onShowFilters: _showFiltersBottomSheet,
                ),
                const SeekReportsList(),
                const SeekReportsPagination(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(child: AppTopBar(showBackButton: false)),
          ),
        ],
      ),
    );
  }
}
