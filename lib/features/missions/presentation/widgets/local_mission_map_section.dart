import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import '../../data/models/mission_model.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class LocalMissionMapSection extends StatelessWidget {
  const LocalMissionMapSection({
    required this.currentPosition,
    required this.markers,
    required this.myLocationEnabled,
    required this.onMapCreated,
    required this.onLocateMe,
    this.onTapMap,
    this.selectedMission,
    this.circles = const {},
    super.key,
  });

  final LatLng currentPosition;
  final Set<Marker> markers;
  final bool myLocationEnabled;
  final ValueChanged<GoogleMapController> onMapCreated;
  final VoidCallback onLocateMe;
  final VoidCallback? onTapMap;
  final dynamic selectedMission;
  final Set<Circle> circles;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition,
                zoom: 12,
              ),
              onMapCreated: onMapCreated,
              onTap: (_) => onTapMap?.call(),
              markers: markers,
              circles: circles,
              myLocationEnabled: myLocationEnabled,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            if (selectedMission != null)
              Positioned(
                top: 77,
                left: 16,
                right: 16,
                child: _MissionMapCard(
                  mission: selectedMission as MissionModel,
                ),
              ),
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 2,
                child: IconButton(
                  onPressed: onLocateMe,
                  icon: const Icon(
                    Icons.my_location,
                    color: PartnerUiColors.brand,
                    size: 20,
                  ),
                  tooltip: 'Locate me',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionMapCard extends StatelessWidget {
  const _MissionMapCard({required this.mission});

  final MissionModel mission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 180),
        child: Container(
          decoration: BoxDecoration(
            color: PartnerUiColors.brand,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: ClipOval(
                      child:
                          mission.photo != null
                              ? Image.network(
                                mission.photo!.secureUrl,
                                fit: BoxFit.cover,
                              )
                              : Container(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontFamily: 'EricaOne',
                            fontSize: 9,
                            height: 1,
                          ),
                        ),
                        Text(
                          mission.partner?.company ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontSize: 6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          l10n.missionDuration.replaceAll(
                            '{duration}',
                            mission.duration,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontSize: 6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  // Handle see mission
                },
                child: Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF4E9),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.seeMission,
                      maxLines: 1,
                      style: AppTextStyles.body.copyWith(
                        color: PartnerUiColors.brand,
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
