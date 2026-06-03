import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../missions/mission_local.dart';
import '../../authorities.dart';
import '../../faq_community.dart';
import '../../partners.dart';
import '../../shelters.dart';
import '../../veterinarians.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class CommunityBottomSections extends StatelessWidget {
  const CommunityBottomSections({
    super.key,
    required this.currentPosition,
    required this.markers,
    required this.hasReportsError,
    required this.myLocationEnabled,
    required this.onMapCreated,
    required this.onCameraMove,
    required this.onLocateMe,
  });

  final LatLng currentPosition;
  final Set<Marker> markers;
  final bool hasReportsError;
  final bool myLocationEnabled;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<CameraPosition> onCameraMove;
  final VoidCallback onLocateMe;

  static const _brandPrimary = Color(0xFFBA4A22);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          l10n.seeLocalMissions.toUpperCase().replaceAll(' ', '\n'),
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: _brandPrimary,
            height: 0.9,
          ),
        ),
        const SizedBox(height: 20),
        _CommunityMapSection(
          currentPosition: currentPosition,
          markers: markers,
          hasReportsError: hasReportsError,
          myLocationEnabled: myLocationEnabled,
          onMapCreated: onMapCreated,
          onCameraMove: onCameraMove,
          onLocateMe: onLocateMe,
        ),
        const SizedBox(height: 60),
        const _FaqSection(),
        const SizedBox(height: 40),
        const _ContactsSection(),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _CommunityMapSection extends StatelessWidget {
  const _CommunityMapSection({
    required this.currentPosition,
    required this.markers,
    required this.hasReportsError,
    required this.myLocationEnabled,
    required this.onMapCreated,
    required this.onCameraMove,
    required this.onLocateMe,
  });

  final LatLng currentPosition;
  final Set<Marker> markers;
  final bool hasReportsError;
  final bool myLocationEnabled;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<CameraPosition> onCameraMove;
  final VoidCallback onLocateMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: CommunityBottomSections._brandPrimary.withValues(
                alpha: 0.1,
              ),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPosition,
                  zoom: 12,
                ),
                onMapCreated: onMapCreated,
                markers: markers,
                myLocationEnabled: myLocationEnabled,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onCameraMove: onCameraMove,
              ),
              if (hasReportsError)
                Positioned.fill(
                  child: Container(
                    color: Colors.black12,
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: onLocateMe,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.my_location,
                color: CommunityBottomSections._brandPrimary,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MissionLocalScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              decoration: BoxDecoration(
                color: CommunityBottomSections._brandPrimary,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                AppLocalizations.of(context).seeFullList.toUpperCase(),
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            l10n.faqNoQuestionsTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: CommunityBottomSections._brandPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FAQCommunityScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: CommunityBottomSections._brandPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.goToFaq.toUpperCase(),
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(05),
                  child: Image.asset(
                    AppAssets.faqImage,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactsSection extends StatelessWidget {
  const _ContactsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            AppAssets.contactBackground,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // Dark overlay
          Positioned.fill(
            child: ColoredBox(color: Colors.black.withValues(alpha: 0.45)),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.contactsTitle,
                style: AppTextStyles.body.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  _ContactButton(
                    label: l10n.sheltersLabel,
                    screen: const SheltersScreen(),
                  ),
                  _ContactButton(
                    label: l10n.veterinariansLabel,
                    screen: const VeterinariansScreen(),
                  ),
                  _ContactButton(
                    label: l10n.authoritiesLabel,
                    screen: const AuthoritiesScreen(),
                  ),
                  _ContactButton(
                    label: l10n.partnersLabel,
                    screen: const PartnersScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.label, required this.screen});

  final String label;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF6E5),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: CommunityBottomSections._brandPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
