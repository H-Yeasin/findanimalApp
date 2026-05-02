import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';
import 'package:hesteka_frontend/features/Collection_Point/collection_point.dart';
import 'package:hesteka_frontend/features/Community/presentation/providers/contact_providers.dart';
import 'package:hesteka_frontend/features/partner_ads/presentation/providers/partner_collection_points_provider.dart';
import 'package:hesteka_frontend/features/solidarity/presentation/screens/make_donation_screen.dart';
import '../../../../core/localization/app_localizations.dart';

import '../../../../core/routing/route_names.dart';

class SolidarityHubScreen extends ConsumerWidget {
  const SolidarityHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    const brandPrimary = Color(0xFFBA4A22);
    const surface = Color(0xFFFBF4E9);

    return Scaffold(
      backgroundColor: surface,
      body: CustomPaint(
        painter: _GridPainter(),
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Image with TOGETHER text
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/soliderityHeader.png',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.black.withValues(alpha: 0.1),
                        ),
                        Positioned(
                          bottom: 40,
                          child: Text(
                            l10n.together,
                            style: AppTextStyles.display.copyWith(
                              fontSize: 60,
                              color: surface,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    // Donation Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        l10n.solidarityDescription,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: brandPrimary,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // MAKE A DONATION Button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MakeDonationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 45,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: brandPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.makeDonation.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    // Collection Points Title
                    Text(
                      l10n.collectionPoints.toUpperCase(),
                      style: AppTextStyles.condensedSectionTitle.copyWith(
                        fontSize: 27,
                      ),
                    ),
                    Text(
                      l10n.collectionPointsAround,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 14,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Map Section
                    ref
                        .watch(allCollectionPointsProvider)
                        .when(
                          data: (points) {
                            final markers = points
                                .where(
                                  (p) =>
                                      p.latitude != null && p.longitude != null,
                                )
                                .map(
                                  (p) => Marker(
                                    markerId: MarkerId(p.id),
                                    position: LatLng(p.latitude!, p.longitude!),
                                    infoWindow: InfoWindow(
                                      title: p.title,
                                      snippet: p.address,
                                    ),
                                  ),
                                )
                                .toSet();

                            return Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 280,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: brandPrimary.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: GoogleMap(
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                        target: markers.isNotEmpty
                                            ? markers.first.position
                                            : const LatLng(
                                                43.6047,
                                                1.4442,
                                              ), // Default to France
                                        zoom: 14.0,
                                      ),
                                      markers: markers,
                                      myLocationEnabled: false,
                                      myLocationButtonEnabled: false,
                                      zoomControlsEnabled: false,
                                      mapToolbarEnabled: false,
                                    ),
                                  ),
                                ),
                                // SEE MORE Button
                                Positioned(
                                  bottom: -20,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CollectionPointScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 60,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFBF4E9),
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: brandPrimary.withValues(
                                            alpha: 0.5,
                                          ),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        l10n.homeSeeMore.toUpperCase(),
                                        style: const TextStyle(
                                          color: brandPrimary,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () => const SizedBox(
                            height: 280,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (err, stack) => Container(
                            height: 280,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.grey.withValues(alpha: 0.1),
                            child: Center(
                              child: Text('Error loading map: $err'),
                            ),
                          ),
                        ),

                    const SizedBox(height: 50),
                    // Collection Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: l10n.collectionPointsDescription,
                            ),
                            TextSpan(
                              text: l10n.donatingNearYou,
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: brandPrimary,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    // BY OUR SIDE Title
                    Text(
                      l10n.thoseWhoAre,
                      style: const TextStyle(
                        fontSize: 14,
                        color: brandPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.byOurSide,
                      style: AppTextStyles.heading.copyWith(fontSize: 42),
                    ),
                    const SizedBox(height: 20),

                    // Partner Logos (Dynamic)
                    ref.watch(partnersProvider).when(
                          data: (partners) {
                            final validPartners = partners
                                .where(
                                  (p) =>
                                      p.fullImageUrl != null &&
                                      p.fullImageUrl!.isNotEmpty,
                                )
                                .toList();
                            if (validPartners.isEmpty) return const SizedBox();

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                children: validPartners
                                    .map(
                                      (p) => _buildPartnerLogo(
                                        p.fullImageUrl!,
                                        brandPrimary,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => const SizedBox(),
                        ),

                    const SizedBox(height: 50),
                    // Shop Section
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/images/solidarity_shop.png',
                            height: 280,
                            width: MediaQuery.of(context).size.width * 0.9,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 280,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  color: brandPrimary.withValues(alpha: 0.1),
                                  child: const Icon(
                                    Icons.shopping_bag,
                                    size: 50,
                                    color: brandPrimary,
                                  ),
                                ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          child: Text(
                            l10n.solidarityShopTitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.heading.copyWith(fontSize: 38),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        l10n.shopDescription,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: brandPrimary,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // VIEW THE SHOP Button
                    GestureDetector(
                      onTap: () {
                        context.push(RouteNames.solidarityShop);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 100),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: brandPrimary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          l10n.viewShop.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), // SingleChildScrollView
            ), // SafeArea
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(child: AppTopBar(showBackButton: false)),
            ),
          ], // Stack children
        ), // Stack
      ), // CustomPaint
    );
  }

  Widget _buildPartnerLogo(String imageUrl, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.store, color: color, size: 30),
        ),
      ),
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
