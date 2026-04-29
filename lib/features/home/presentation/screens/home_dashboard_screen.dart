import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/features/solidarity/presentation/screens/solidarity_hub_screen.dart';
import 'package:hesteka_frontend/features/solidarity/presentation/screens/solidarity_shop_screen.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Community/community_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../solidarity/presentation/screens/make_donation_screen.dart';
import '../../../seek/presentation/screens/seek_reports_screen.dart';
import '../../../seek/presentation/screens/animal_profile_screen.dart';
import '../../../reports/presentation/screens/my_reports_screen.dart';
import '../../../missions/mission_local.dart';
import '../../../seek/data/models/report_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_providers.dart';

class HomeDashboard extends ConsumerStatefulWidget {
  const HomeDashboard({super.key});

  @override
  ConsumerState<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends ConsumerState<HomeDashboard> {
  // Let's use index 2 (the middle logo button) as the primary Home Feed index by default
  int _currentIndex = 2;

  // List of all the screens for the bottom navigation
  final List<Widget> _pages = [
    const SeekReportsScreen(),
    const MyReportsScreen(),
    // We will render the beautiful Home Feed layout we built when index == 2
    // You can swap this with `MiddleNavScreen()` if you want the blank placeholder
    const SizedBox.shrink(),
    const CommunityScreen(),
    const SolidarityHubScreen(),
  ];

  // A standalone Navigator key specifically for routing screens Above the feed but Below the bottom nav
  final GlobalKey<NavigatorState> _nestedNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Automatically try to get location on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
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
    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      _updateLocationFilters(position.latitude, position.longitude);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Location updated!')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not get location: $e')));
    }
  }

  void _updateLocationFilters(double lat, double lng) {
    if (!mounted) return;
    final currentFilters = ref.read(homeReportFiltersProvider);
    ref.read(homeReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'lat': lat,
      'lng': lng,
      'radius': 10, // Default 10km radius
      'page': 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      body: Navigator(
        key: _nestedNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return IndexedStack(
                index: _currentIndex,
                children: [
                  _pages[0],
                  _pages[1],
                  // Index 2 is the Home Dashboard feed we built!
                  Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTopHeader(ref),
                            _buildInfoBanner(context),
                            _buildMapSection(),
                            _buildFilters(),
                            _buildReportedRecently(ref),
                            _buildCommunityHelped(ref),
                            _buildSupportSection(),
                          ],
                        ),
                      ),
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: AppTopBar(showBackButton: false),
                        ),
                      ),
                    ],
                  ),
                  _pages[3],
                  _pages[4],
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // If we are currently showing a pushed route (like Login/Signup),
          // pop it back to the home/root state when switching tabs.
          if (_nestedNavigatorKey.currentState!.canPop()) {
            _nestedNavigatorKey.currentState!.popUntil(
              (route) => route.isFirst,
            );
          }

          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildTopHeader(WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final _ = currentUser?.profileImage;

    return Stack(
      children: [
        // Background Image Header
        Container(
          height: 350,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/homeHero.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Removed AppTopBar from here, it's now pinned above the scroll view
        // Logo
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/Logo/logo.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  // "Welcome to" text perfectly nestled above the 'ESTEKA' part of the logo
                  const Align(
                    alignment: Alignment(
                      0.1,
                      0.1,
                    ), // Roughly above the E, right of the cat
                    child: Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      color: const Color(0xFFC65D3B), // Match brand orange
      child: Text(
        AppLocalizations.of(context).homeInfoBanner,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    final reportsAsync = ref.watch(homeReportsProvider);
    final LatLng initialLocation = const LatLng(
      48.8566,
      2.3522,
    ); // Paris default

    Set<Marker> markers = {};
    if (reportsAsync.hasValue) {
      for (var report in reportsAsync.value!) {
        if (report.location.coordinates.length >= 2) {
          markers.add(
            Marker(
              markerId: MarkerId('home_${report.id}'),
              position: LatLng(
                report.location.coordinates[1],
                report.location.coordinates[0],
              ),
              infoWindow: InfoWindow(
                title: report.animalName.toUpperCase(),
                snippet: '${report.status} | ${report.breed}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                report.status.toLowerCase() == 'found'
                    ? BitmapDescriptor.hueAzure
                    : BitmapDescriptor.hueOrange,
              ),
            ),
          );
        }
      }
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 250,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFF2E6D8), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialLocation,
                zoom: 11,
              ),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
        ),
        // Locate Me Button
        Positioned(
          top: 15,
          right: 35,
          child: GestureDetector(
            onTap: _handleLocateMe,
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
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -15,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 0; // Switch to SEEK (Reports) tab
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFBA4A22),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFBA4A22).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'EXPLORE FULL MAP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  fontFamily: 'Impact',
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: GestureDetector(
        onTap: () {
          _showFiltersBottomSheet(context, ref);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFEFE1D1), width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'FILTERS',
                style: TextStyle(
                  color: Color(0xFFBA4A22),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 100),
              Icon(Icons.keyboard_arrow_down, color: Color(0xFFBA4A22)),
            ],
          ),
        ),
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const _FiltersBottomSheet();
      },
    );
  }

  Widget _buildReportedRecently(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            'REPORTED RECENTLY',
            style: TextStyle(
              color: Color(0xFFBA4A22),
              fontSize: 32,
              fontWeight: FontWeight.w900,
              fontFamily: 'Impact', // Provide a chunky system font fallback
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            'NEAR YOU',
            style: TextStyle(
              color: Color(0xFFBA4A22),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 25),
          ref
              .watch(homeReportsProvider)
              .when(
                data: (reports) {
                  if (reports.isEmpty) {
                    return const Center(
                      child: Text(
                        'No reports found near you.',
                        style: TextStyle(color: Color(0xFFBA4A22)),
                      ),
                    );
                  }
                  return Column(
                    children: reports
                        .map(
                          (report) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildAnimalCard(report),
                          ),
                        )
                        .toList(),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
                ),
                error: (error, stack) =>
                    Center(child: Text('Error loading reports: $error')),
              ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 0; // Switch to SEEK (Reports) tab
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFBA4A22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'SEE MORE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAnimalCard(ReportModel report) {
    final name = report.animalName.toUpperCase();
    final details =
        '${report.age} | ${report.species} | ${report.breed} | ${report.status}';
    final timeFormatted = DateFormat('MMM d, h:mm a').format(report.eventDate);
    final imagePath = report.images.isNotEmpty
        ? report.images.first.secureUrl
        : 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&q=80&w=1000';
    final button1Text = 'VIEW ON THE MAP';
    final button2Text = "VIEW $name'S PROFILE";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4), // Light cream-orange
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                width: 80,
                height: 80,
                color: Colors.grey,
                child: const Icon(Icons.image),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xFFBA4A22),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeFormatted,
                      style: const TextStyle(
                        color: Color(0xFFD3A482),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: const TextStyle(
                    color: Color(0xFFBA4A22),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 0; // Switch to SEEK (Reports) tab
                        });
                      },
                      child: _buildOutlinedButton(button1Text),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _nestedNavigatorKey.currentState!.push(
                            MaterialPageRoute(
                              builder: (context) => AnimalProfileScreen(
                                data: AnimalProfileData(
                                  id: report.id,
                                  name: name,
                                  details: details,
                                  time: timeFormatted,
                                  status:
                                      '${report.status} on ${DateFormat('dd/MM/yy').format(report.eventDate)}',
                                  description: report.description,
                                  imageUrl: imagePath,
                                  ownerName: report.author != null
                                      ? '${report.author!.firstName} ${report.author!.lastName}'
                                      : 'Community User',
                                  isPlaceholder: report.images.isEmpty,
                                ),
                              ),
                            ),
                          );
                        },
                        child: _buildFilledButton(button2Text),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton(String text) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFBA4A22),
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            fontFamily: 'Impact',
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
  }

  Widget _buildFilledButton(String text) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFBA4A22),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            fontFamily: 'Impact',
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
  }

  Widget _buildCommunityHelped(WidgetRef ref) {
    final statsAsync = ref.watch(homeStatsProvider);

    return Container(
      width: double.infinity,
      color: const Color(0xFFAB4523), // Darker orange
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'THE COMMUNITY HELPED',
            style: TextStyle(
              color: Color(0xFFF9EAD4),
              fontSize: 28,
              fontWeight: FontWeight.w900,
              fontFamily: 'Impact',
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          statsAsync.when(
            data: (stats) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCircle(
                  stats['ANIMALS FOUND'] ?? '0',
                  'ANIMALS FOUND',
                ),
                _buildStatCircle(stats['REPORTS'] ?? '0', 'REPORTS'),
                _buildStatCircle(
                  stats['ANIMALS RESCUED'] ?? '0',
                  'ANIMALS RESCUED',
                ),
              ],
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFFF9EAD4)),
            ),
            error: (error, stack) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCircle('0', 'ANIMALS FOUND'),
                _buildStatCircle('0', 'REPORTS'),
                _buildStatCircle('0', 'ANIMALS RESCUED'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCircle(String number, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF9EAD4), width: 1.5),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFFF9EAD4),
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF9EAD4),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Text(
            'I SUPPORT',
            style: TextStyle(
              color: Color(0xFFBA4A22),
              fontSize: 32,
              fontWeight: FontWeight.w900,
              fontFamily: 'Impact',
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildSupportButton(
                      'I MAKE A DONATION',
                      onTap: () {
                        _nestedNavigatorKey.currentState!.push(
                          MaterialPageRoute(
                            builder: (context) => const MakeDonationScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSupportButton(
                      'SOLIDARITY SHOP',
                      onTap: () {
                        _nestedNavigatorKey.currentState!.push(
                          MaterialPageRoute(
                            builder: (context) => const SolidarityShopScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSupportButton(
                      'SIGN UP FOR A MISSION',
                      onTap: () {
                        _nestedNavigatorKey.currentState!.push(
                          MaterialPageRoute(
                            builder: (context) => const MissionLocalScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'You can support us in various ways, either by making a donation, purchasing an item from the solidarity shop, or signing up for local missions to volunteer with our partner organizations.',
                      style: TextStyle(
                        color: Color(0xFFBA4A22),
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Every action earns you points on your account and helps us grow the collective impact.',
                      style: TextStyle(
                        color: Color(0xFFBA4A22),
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSupportButton(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFBA4A22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _FiltersBottomSheet extends ConsumerStatefulWidget {
  const _FiltersBottomSheet();

  @override
  ConsumerState<_FiltersBottomSheet> createState() =>
      _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends ConsumerState<_FiltersBottomSheet> {
  late TextEditingController _searchController;
  late double _radius;
  late String _status;

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(homeReportFiltersProvider);
    _searchController = TextEditingController(
      text: currentFilters['search'] ?? '',
    );
    _radius = (currentFilters['radius'] as num?)?.toDouble() ?? 5.0;
    _status = currentFilters['status'] ?? 'all';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBA4A22),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFFBA4A22)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search (e.g. Buddy)',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFBA4A22)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFBA4A22),
            ),
          ),
          DropdownButton<String>(
            value: _status,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All')),
              DropdownMenuItem(value: 'missing', child: Text('Missing')),
              DropdownMenuItem(value: 'found', child: Text('Found')),
              DropdownMenuItem(value: 'rescued', child: Text('Rescued')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _status = val);
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Radius: ${_radius.toInt()} km',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFBA4A22),
            ),
          ),
          Slider(
            value: _radius,
            min: 1,
            max: 50,
            activeColor: const Color(0xFFBA4A22),
            onChanged: (val) {
              setState(() => _radius = val);
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA4A22),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                final currentFilters = ref.read(homeReportFiltersProvider);
                final updatedFilters = Map<String, dynamic>.from(
                  currentFilters,
                );

                if (_searchController.text.trim().isNotEmpty) {
                  updatedFilters['search'] = _searchController.text.trim();
                } else {
                  updatedFilters.remove('search');
                }

                updatedFilters['status'] = _status;

                // Fetch actual device location to make the radius search work properly
                try {
                  bool serviceEnabled =
                      await Geolocator.isLocationServiceEnabled();
                  if (serviceEnabled) {
                    LocationPermission permission =
                        await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                    }
                    if (permission == LocationPermission.whileInUse ||
                        permission == LocationPermission.always) {
                      final position = await Geolocator.getCurrentPosition();
                      updatedFilters['lat'] = position.latitude;
                      updatedFilters['lng'] = position.longitude;
                      updatedFilters['radius'] = _radius.toInt();
                      // Backend ignores sortBy=date when lat/lng are provided, which is expected for proximity search
                      updatedFilters.remove('sortBy');
                      updatedFilters.remove('sort');
                    }
                  }
                } catch (e) {
                  // Fallback to ignoring location if permission denied
                  updatedFilters.remove('lat');
                  updatedFilters.remove('lng');
                  updatedFilters.remove('radius');
                }

                // Reset page to 1 on new filter
                updatedFilters['page'] = 1;

                if (!context.mounted) return;
                ref.read(homeReportFiltersProvider.notifier).state =
                    updatedFilters;
                Navigator.pop(context);
              },
              child: const Text(
                'APPLY FILTERS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
