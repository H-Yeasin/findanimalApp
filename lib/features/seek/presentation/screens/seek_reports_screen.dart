import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/seek_reports_provider.dart';
import '../providers/seek_report_filters_provider.dart';
import 'animal_profile_screen.dart';

class GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFFFFECDB) // Subtle peach grid line
      ..strokeWidth = 1.0;

    const double step = 60.0; // Grid square size

    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SeekReportsScreen extends ConsumerStatefulWidget {
  const SeekReportsScreen({super.key});

  @override
  ConsumerState<SeekReportsScreen> createState() => _SeekReportsScreenState();
}

class _SeekReportsScreenState extends ConsumerState<SeekReportsScreen> {
  final LatLng _initialLocation = const LatLng(
    48.8566,
    2.3522,
  ); // Default to Paris

  @override
  void initState() {
    super.initState();
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
    final currentFilters = ref.read(seekReportFiltersProvider);
    ref.read(seekReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'lat': lat,
      'lng': lng,
      'radius': 10,
      'page': 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(child: CustomPaint(painter: GridBackgroundPainter())),
          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, ref, l10n),
                _buildMapAndFilters(context, ref, l10n),
                _buildReportCards(context, ref, l10n),
                _buildPagination(context, ref),
                const SizedBox(height: 100), // Padding for the fixed bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFBA4A22).withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Centered Title
              Text(
                l10n.seekViewReports,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Impact',
                  letterSpacing: 1.2,
                ),
              ),
              // Profile Icon on the Right
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    final authStatus = ref.read(authStateProvider);
                    if (authStatus == AuthStatus.authenticated) {
                      context.push(RouteNames.myProfile);
                    } else {
                      context.push(RouteNames.account);
                    }
                  },
                  child: UserAvatar(
                    imageUrl: ref.watch(currentUserProvider)?.profileImage,
                    radius: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapAndFilters(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final filters = ref.watch(seekReportFiltersProvider);
    final status = filters['status'] ?? 'all';
    final radius = filters['radius'] ?? 5;
    final hasLocation = filters.containsKey('lat');
    final reportsAsync = ref.watch(seekReportsProvider);

    Set<Marker> markers = {};
    if (reportsAsync.hasValue) {
      for (var report in reportsAsync.value!.data) {
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

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Real Google Map
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF2E6D8), width: 1),
                ),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialLocation,
                  zoom: 12,
                ),
                onMapCreated: (controller) {
                  // Optional: animate to user location or markers
                },
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),

            // Locate Me Button
            Positioned(
              top: 15,
              right: 20,
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
                    size: 22,
                  ),
                ),
              ),
            ),

            // FILTERS Dropdown (Overlapping bottom edge)
            Positioned(
              bottom: -28, // Half-on / Half-off the map
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () => _showFiltersBottomSheet(context, ref, 'all'),
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
                        style: TextStyle(
                          color: Color(0xFFBA4A22),
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          fontFamily: 'Impact',
                        ),
                      ),
                      Icon(
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
        const SizedBox(height: 45), // Space for the overlapping box
        // Pill buttons (Sorted by & Location)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showFiltersBottomSheet(context, ref, 'sort'),
                  child: _buildFilterPill(
                    status.toString().toUpperCase(),
                    Icons.keyboard_arrow_down,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () =>
                      _showFiltersBottomSheet(context, ref, 'location'),
                  child: _buildFilterPill(
                    hasLocation ? l10n.nearbyKm(radius) : l10n.globalSearch,
                    Icons.keyboard_arrow_down,
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

  void _showFiltersBottomSheet(
    BuildContext context,
    WidgetRef ref,
    String initialSection,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return _FiltersBottomSheet(initialSection: initialSection);
      },
    );
  }

  Widget _buildFilterPill(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFBA4A22),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(icon, color: Colors.white, size: 18),
        ],
      ),
    );
  }

  Widget _buildReportCards(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final reportsAsync = ref.watch(seekReportsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: reportsAsync.when(
        data: (paginatedData) {
          final reports = paginatedData.data;
          if (reports.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  l10n.noReportsFound,
                  style: const TextStyle(
                    color: Color(0xFFBA4A22),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: reports.map((report) {
              final isFound = report.status.toLowerCase() == 'found';
              final actionVerb = isFound ? 'Found' : 'Lost';
              final details =
                  '${report.age} | ${report.species} | ${report.breed} | $actionVerb';

              String timeFormatted = DateFormat(
                'MMM d, yyyy - h:mm a',
              ).format(report.eventDate.toLocal());

              String imageUrl = '';
              bool isPlaceholder = true;
              if (report.images.isNotEmpty) {
                imageUrl = report.images.first.secureUrl;
                isPlaceholder = false;
              }

              final ownerName = 'Unknown';

              final displayName = report.animalName.isNotEmpty
                  ? report.animalName.toUpperCase()
                  : report.species.toUpperCase();

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildAnimalCard(
                  context: context,
                  id: report.id,
                  name: displayName,
                  details: details,
                  time: timeFormatted,
                  imageUrl: imageUrl,
                  ownerName: ownerName,
                  description: report.description,
                  status: report.status,
                  isPlaceholder: isPlaceholder,
                ),
              );
            }).toList(),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
          ),
        ),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              l10n.errorLoadingReports,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimalCard({
    required BuildContext context,
    required String id,
    required String name,
    required String details,
    required String time,
    required String imageUrl,
    required String ownerName,
    required String description,
    required String status,
    bool isPlaceholder = false,
  }) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFBA4A22).withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: isPlaceholder ? const Color(0xFFFBF4E9) : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFBA4A22).withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: isPlaceholder
                  ? const Center(
                      child: Icon(
                        Icons.pets,
                        color: Color(0xFFBA4A22),
                        size: 40,
                      ),
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          Container(color: Colors.grey[200]),
                    ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xFFBA4A22),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Impact',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFFD3A482),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -2),
                  child: Text(
                    details,
                    style: const TextStyle(
                      color: Color(0xFFBA4A22),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSmallButton(
                      l10n.viewOnMap,
                      isFilled: false,
                      onTap: () {
                        // View on map logic
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSmallButton(
                        l10n.viewProfile(name.toUpperCase()),
                        isFilled: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AnimalProfileScreen(
                                data: AnimalProfileData(
                                  id: id,
                                  name: name,
                                  details: details,
                                  time: time,
                                  status: status,
                                  description: description,
                                  imageUrl: imageUrl,
                                  ownerName: ownerName,
                                  isPlaceholder: isPlaceholder,
                                ),
                              ),
                            ),
                          );
                        },
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

  Widget _buildSmallButton(
    String text, {
    required bool isFilled,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isFilled ? const Color(0xFFBA4A22) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              color: isFilled ? Colors.white : const Color(0xFFBA4A22),
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              fontFamily: 'Impact',
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }

  Widget _buildPagination(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(seekReportsProvider);

    return reportsAsync.maybeWhen(
      data: (paginatedData) {
        final currentPage = paginatedData.page;
        final totalPages = paginatedData.totalPages;

        if (totalPages <= 1) return const SizedBox.shrink();

        List<Widget> pageNodes = [];

        int startPage = (currentPage - 1).clamp(1, totalPages).toInt();
        if (startPage + 2 > totalPages) {
          startPage = (totalPages - 2).clamp(1, totalPages).toInt();
        }
        int endPage = (startPage + 2).clamp(1, totalPages).toInt();

        for (int i = startPage; i <= endPage; i++) {
          pageNodes.add(
            _buildPageNumber(
              i.toString(),
              isActive: i == currentPage,
              onTap: () {
                if (i != currentPage) {
                  ref.read(seekReportsProvider.notifier).goToPage(i);
                }
              },
            ),
          );
          if (i < endPage) {
            pageNodes.add(const SizedBox(width: 20));
          }
        }

        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: currentPage > 1
                    ? () => ref
                          .read(seekReportsProvider.notifier)
                          .goToPage(currentPage - 1)
                    : null,
                child: Icon(
                  Icons.undo,
                  color: currentPage > 1
                      ? const Color(0xFFBA4A22)
                      : Colors.grey,
                  size: 22,
                ),
              ),
              const SizedBox(width: 25),
              ...pageNodes,
              const SizedBox(width: 25),
              GestureDetector(
                onTap: currentPage < totalPages
                    ? () => ref
                          .read(seekReportsProvider.notifier)
                          .goToPage(currentPage + 1)
                    : null,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: currentPage < totalPages
                      ? const Color(0xFFBA4A22)
                      : Colors.grey,
                  size: 22,
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildPageNumber(
    String number, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              number,
              style: TextStyle(
                color: const Color(0xFFBA4A22),
                fontSize: 28,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
                fontFamily: 'Impact',
              ),
            ),
            if (isActive)
              Container(
                width: 20,
                height: 2.5,
                color: const Color(0xFFBA4A22),
                margin: const EdgeInsets.only(top: 2),
              ),
          ],
        ),
      ),
    );
  }
}

class _FiltersBottomSheet extends ConsumerStatefulWidget {
  final String initialSection;
  const _FiltersBottomSheet({this.initialSection = 'all'});

  @override
  ConsumerState<_FiltersBottomSheet> createState() =>
      _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends ConsumerState<_FiltersBottomSheet> {
  late TextEditingController _searchController;
  late double _radius;
  late String _status;
  late String _sortBy;
  late String _sort;

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(seekReportFiltersProvider);
    _searchController = TextEditingController(
      text: currentFilters['search'] ?? '',
    );
    _radius = (currentFilters['radius'] as num?)?.toDouble() ?? 5.0;
    _status = currentFilters['status'] ?? 'all';
    _sortBy = currentFilters['sortBy'] ?? 'date';
    _sort = currentFilters['sort'] ?? 'descending';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: Color(0xFFBA4A22),
          fontFamily: 'Impact',
          letterSpacing: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        left: 24,
        right: 24,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.adjustFilters,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFBA4A22),
                    fontFamily: 'Impact',
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFFBA4A22),
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1, color: Color(0xFFF2E6D8)),

            _buildSectionTitle(l10n.searchAnimal),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHintExample,
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFBA4A22)),
                filled: true,
                fillColor: const Color(0xFFFBF4E9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),

            _buildSectionTitle(l10n.status),
            Wrap(
              spacing: 10,
              children: ['all', 'missing', 'found', 'rescued'].map((s) {
                final isSelected = _status == s;
                return ChoiceChip(
                  label: Text(s.toUpperCase()),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _status = s);
                  },
                  selectedColor: const Color(0xFFBA4A22),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFBA4A22),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: const Color(0xFFBA4A22),
                      width: isSelected ? 0 : 1,
                    ),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),

            _buildSectionTitle(l10n.searchRadius),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFFBA4A22),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.radiusValue(_radius.toInt()),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Slider(
              value: _radius,
              min: 1,
              max: 50,
              activeColor: const Color(0xFFBA4A22),
              inactiveColor: const Color(0xFFF2E6D8),
              onChanged: (val) {
                setState(() => _radius = val);
              },
            ),

            _buildSectionTitle(l10n.sortBy),
            DropdownButtonFormField<String>(
              initialValue: _sortBy,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFBF4E9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'date', child: Text(l10n.date)),
                DropdownMenuItem(value: 'name', child: Text(l10n.name)),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _sortBy = val);
              },
            ),

            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA4A22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  final updatedFilters = <String, dynamic>{
                    'page': 1,
                    'limit': 10,
                    'status': _status,
                    'sortBy': _sortBy,
                    'sort': _sort,
                  };

                  if (_searchController.text.trim().isNotEmpty) {
                    updatedFilters['search'] = _searchController.text.trim();
                  }

                  // Always try to get location for Seek screen to support proximity
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
                        // Backend logic: lat/lng provided means proximity sort
                      }
                    }
                  } catch (e) {
                    // Fallback to global if location fails
                  }

                  if (!context.mounted) return;
                  ref.read(seekReportFiltersProvider.notifier).state =
                      updatedFilters;
                  Navigator.pop(context);
                },
                child: Text(
                  l10n.applyFilters,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Impact',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
