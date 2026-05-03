import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/features/solidarity/presentation/screens/solidarity_hub_screen.dart';

import '../../../Community/community_screen.dart';
import '../../../missions/mission_local.dart';
import '../../../reports/presentation/screens/my_reports_screen.dart';
import '../../../seek/presentation/screens/seek_reports_screen.dart';
import '../../../solidarity/presentation/screens/make_donation_screen.dart';
import '../../../solidarity/presentation/screens/solidarity_shop_screen.dart';
import '../../../../core/providers/location_provider.dart';
import '../providers/home_providers.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/home_feed.dart';


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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    final userLoc = await ref.read(userLocationProvider.future);
    if (userLoc == null || !mounted) return;
    _updateLocationFilters(userLoc.latitude, userLoc.longitude);
  }

  Future<void> _handleLocateMe() async {
    final l10n = AppLocalizations.of(context);
    // Invalidate the provider to force a re-fetch of the current position
    ref.invalidate(userLocationProvider);
    final userLoc = await ref.read(userLocationProvider.future);

    if (!mounted) return;

    if (userLoc == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.couldNotGetLocation)));
      return;
    }

    _updateLocationFilters(userLoc.latitude, userLoc.longitude);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.locationUpdated)));
  }

  void _updateLocationFilters(double lat, double lng) {
    if (!mounted) return;
    final currentFilters = ref.read(homeReportFiltersProvider);
    ref.read(homeReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'lat': lat,
      'lng': lng,
      'radius': currentFilters['radius'] ?? 10,
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



  void _selectTab(int index) {
    if (_currentIndex == _homeTabIndex &&
        (_nestedNavigatorKey.currentState?.canPop() ?? false)) {
      _nestedNavigatorKey.currentState!.popUntil((route) => route.isFirst);
    }

    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildTabBody() {
    switch (_currentIndex) {
      case _reportsTabIndex:
        return const SeekReportsScreen();
      case 1:
        return const MyReportsScreen();
      case 3:
        return const CommunityScreen();
      case 4:
        return const SolidarityHubScreen();
      case _homeTabIndex:
      default:
        return Navigator(
          key: _nestedNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                return HomeFeed(
                   onLocateMe: _handleLocateMe,
                   onOpenReports: _openReportsTab,
                   onOpenDonation: () => _pushNested(const MakeDonationScreen()),
                   onOpenShop: () => _pushNested(const SolidarityShopScreen()),
                   onOpenMission: () => _pushNested(const MissionLocalScreen()),
                 );
              },
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        //backgroundColor: const Color(0xFFFBF4E9),
        child: _buildTabBody(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _selectTab,
      ),
    );
  }
}
