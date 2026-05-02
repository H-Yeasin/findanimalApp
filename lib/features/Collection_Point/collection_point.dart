import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hesteka_frontend/features/partner_ads/data/models/partner_ad_model.dart';
import 'package:hesteka_frontend/features/partner_ads/presentation/providers/partner_ads_filters_provider.dart';
import 'package:hesteka_frontend/features/partner_ads/presentation/providers/partner_collection_points_provider.dart';
import 'collections_points_details.dart';

class CollectionPointScreen extends ConsumerWidget {
  const CollectionPointScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const brandPrimary = Color(0xFFBA4A22);
    const surface = Color(0xFFFBF4E9);
    const cardBg = Color(0xFFFFF6E5);

    final l10n = AppLocalizations.of(context);
    final pointsAsync = ref.watch(allCollectionPointsProvider);
    final filters = ref.watch(partnerAdsFiltersProvider);
    final filterNotifier = ref.read(partnerAdsFiltersProvider.notifier);

    return Scaffold(
      backgroundColor: surface,
      body: CustomPaint(
        painter: _GridPainter(),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(brandPrimary, l10n),
              Expanded(
                child: pointsAsync.when(
                  data: (points) => SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          child: Text(
                            l10n.collectionPointsFullDescription,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: brandPrimary,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                        ),
                        _buildMapSection(brandPrimary, points),
                        const SizedBox(height: 20),
                        _buildFilters(brandPrimary, filterNotifier, l10n),
                        const SizedBox(height: 20),
                        _buildCollectionPointsList(
                          context,
                          brandPrimary,
                          cardBg,
                          points,
                          l10n,
                        ),
                        const SizedBox(height: 20),
                        _buildPagination(
                          brandPrimary,
                          filters.page,
                          filterNotifier,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color color, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            l10n.collectionPoints.toUpperCase(),
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Color(0xFFBA4A22),
              letterSpacing: -1,
              fontFamily: 'EricaOne',
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const CircleAvatar(
                backgroundColor: Color(0xFFBA4A22),
                radius: 20,
                child: Icon(Icons.person, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(Color color, List<PartnerAdModel> points) {
    final markers = points
        .where((p) => p.latitude != null && p.longitude != null)
        .map(
          (p) => Marker(
            markerId: MarkerId(p.id),
            position: LatLng(p.latitude!, p.longitude!),
            infoWindow: InfoWindow(title: p.title, snippet: p.address),
          ),
        )
        .toSet();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: markers.isNotEmpty
                ? markers.first.position
                : const LatLng(43.6047, 1.4442),
            zoom: 13.0,
          ),
          markers: markers,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }

  Widget _buildFilters(
    Color color,
    PartnerAdsFiltersNotifier filterNotifier,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'name') {
                  filterNotifier.setSort('title', 'ascending');
                } else if (value == 'newest') {
                  filterNotifier.setSort('date', 'descending');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'name', child: Text(l10n.sortByName)),
                PopupMenuItem(value: 'newest', child: Text(l10n.sortByNewest)),
              ],
              child: _buildFilterButton(l10n.sortBy, color),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PopupMenuButton<double>(
              onSelected: (radius) {
                // Using Pélissanne coordinates from user's example
                filterNotifier.setLocation(43.5333, 5.4331, radius);
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 1, child: Text(l10n.radiusValue(1))),
                PopupMenuItem(value: 5, child: Text(l10n.radiusValue(5))),
                PopupMenuItem(value: 10, child: Text(l10n.radiusValue(10))),
                PopupMenuItem(value: 50, child: Text(l10n.radiusValue(50))),
                PopupMenuItem(value: 0, child: Text(l10n.statusAll)),
              ],
              child: _buildFilterButton(l10n.nearbyKm(5), color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
        ],
      ),
    );
  }

  Widget _buildCollectionPointsList(
    BuildContext context,
    Color color,
    Color cardBg,
    List<PartnerAdModel> points,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: points.map((point) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: _buildCollectionCard(
              context,
              point.title,
              point.partnerCompany ?? point.address,
              point.photoUrl ?? '',
              color,
              cardBg,
              point.latitude,
              point.longitude,
              l10n,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCollectionCard(
    BuildContext context,
    String title,
    String subtitle,
    String logoUrl,
    Color color,
    Color cardBg,
    double? latitude,
    double? longitude,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: logoUrl.startsWith('http')
                  ? Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.store,
                        color: Color(0xFFBA4A22),
                        size: 32,
                      ),
                    )
                  : const Icon(Icons.store, color: Color(0xFFBA4A22), size: 32),
            ),
          ),
          const SizedBox(width: 15),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    fontFamily: 'EricaOne',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: color.withValues(alpha: 0.5),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.seeOnMap.toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CollectionPointsDetailsScreen(
                                title: title,
                                subtitle: subtitle,
                                logoUrl: logoUrl,
                                description: l10n.collectionPointDetailTemplate.replaceAll('{subtitle}', subtitle),
                                latitude: latitude,
                                longitude: longitude,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.seeCollectionPoint.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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

  Widget _buildPagination(
    Color color,
    int currentPage,
    PartnerAdsFiltersNotifier filterNotifier,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: currentPage > 1
              ? () => filterNotifier.setPage(currentPage - 1)
              : null,
          child: Icon(Icons.chevron_left, color: color, size: 24),
        ),
        const SizedBox(width: 10),
        for (int i = 1; i <= 3; i++) ...[
          GestureDetector(
            onTap: () => filterNotifier.setPage(i),
            child: Text(
              '$i',
              style: TextStyle(
                color: Color(0xFFBA4A22),
                fontSize: 18,
                fontWeight: FontWeight.w900,
                decoration: currentPage == i ? TextDecoration.underline : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
        GestureDetector(
          onTap: () => filterNotifier.setPage(currentPage + 1),
          child: Icon(Icons.chevron_right, color: color, size: 24),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBA4A22).withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    double step = 25;

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
