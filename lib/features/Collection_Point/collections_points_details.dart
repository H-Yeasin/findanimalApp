import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';

class CollectionPointsDetailsScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoUrl;
  final String description;
  final double? latitude;
  final double? longitude;

  const CollectionPointsDetailsScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.logoUrl,
    required this.description,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const brandPrimary = AppColors.brandPrimary;
    const cardBg = Color(0xFFFFF6E5);

    return AppBackgroundScaffold(
      showGridFromTop: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppTopBar(showUserAvatar: false),
              const SizedBox(height: 10),
              _buildDetailCard(brandPrimary, cardBg, l10n),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(Color color, Color cardBg, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
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
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.store,
                                color: Color(0xFFBA4A22),
                                size: 40,
                              ),
                        )
                      : const Icon(
                          Icons.store,
                          color: Color(0xFFBA4A22),
                          size: 40,
                        ),
                ),
              ),
              const SizedBox(width: 20),
              // Title Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.startsWith('COLLECTION')
                          ? title
                          : l10n.collectionPointGenericTitle,
                      style: AppTextStyles.heading.copyWith(
                        color: color,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: AppTextStyles.subtitle.copyWith(
                        color: color,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      title, // Using title as the name if it's not a generic header
                      style: AppTextStyles.caption.copyWith(
                        color: color.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            description,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              l10n.collectionPointTogetherHelp,
              style: AppTextStyles.subtitle.copyWith(
                color: color,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 25),
          // Map section
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: latitude != null && longitude != null
                      ? LatLng(latitude!, longitude!)
                      : const LatLng(43.6047, 1.4442),
                  zoom: 15.0,
                ),
                markers: latitude != null && longitude != null
                    ? {
                        Marker(
                          markerId: const MarkerId('selected_point'),
                          position: LatLng(latitude!, longitude!),
                          infoWindow: InfoWindow(title: title),
                        ),
                      }
                    : {},
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // See on map button
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.seeOnMap,
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
