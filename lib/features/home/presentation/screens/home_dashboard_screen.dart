import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/features/solidarity/presentation/screens/solidarity_hub_screen.dart';

import '../../../Community/community_screen.dart';
import '../../../missions/mission_local.dart';
import '../../../reports/presentation/screens/my_reports_screen.dart';
import '../../../seek/presentation/screens/seek_reports_screen.dart';
import '../../../solidarity/presentation/screens/make_donation_screen.dart';
import '../../../solidarity/presentation/screens/solidarity_shop_screen.dart';
import '../providers/home_providers.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/home_feed.dart';
import '../widgets/home_filters_bottom_sheet.dart';

class HomeDashboard extends ConsumerStatefulWidget {
  const HomeDashboard({super.key});

  @override
  ConsumerState<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends ConsumerState<HomeDashboard> {
  static const _reportsTabIndex = 0;
  static const _homeTabIndex = 2;

  int _currentIndex = _homeTabIndex;

  final GlobalKey<NavigatorState> _nestedNavigatorKey =
      GlobalKey<NavigatorState>();

  final List<Widget> _pages = [
    const SeekReportsScreen(),
    const MyReportsScreen(),
    const SizedBox.shrink(),
    const CommunityScreen(),
    const SolidarityHubScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      _updateLocationFilters(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Error initializing location: $e');
    }
  }

  Future<void> _handleLocateMe() async {
    final l10n = AppLocalizations.of(context);
    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      _updateLocationFilters(position.latitude, position.longitude);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.locationUpdated)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.couldNotGetLocation)));
    }
  }

  void _updateLocationFilters(double lat, double lng) {
    if (!mounted) return;
    final currentFilters = ref.read(homeReportFiltersProvider);
    ref.read(homeReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'lat': lat,
      'lng': lng,
      'radius': 10,
      'page': 1,
    };
  }

  void _openReportsTab() {
    setState(() {
      _currentIndex = _reportsTabIndex;
    });
  }

  void _pushNested(Widget screen) {
    _nestedNavigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const HomeFiltersBottomSheet();
      },
    );
  }

  void _selectTab(int index) {
    if (_nestedNavigatorKey.currentState!.canPop()) {
      _nestedNavigatorKey.currentState!.popUntil((route) => route.isFirst);
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        //backgroundColor: const Color(0xFFFBF4E9),
        child: Navigator(
          key: _nestedNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                return IndexedStack(
                  index: _currentIndex,
                  children: [
                    _pages[0],
                    _pages[1],
                    HomeFeed(
                      onLocateMe: _handleLocateMe,
                      onShowFilters: _showFiltersBottomSheet,
                      onOpenReports: _openReportsTab,
                      onOpenDonation: () =>
                          _pushNested(const MakeDonationScreen()),
                      onOpenShop: () =>
                          _pushNested(const SolidarityShopScreen()),
                      onOpenMission: () =>
                          _pushNested(const MissionLocalScreen()),
                    ),
                    _pages[3],
                    _pages[4],
                  ],
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _selectTab,
      ),
    );
  }
}
