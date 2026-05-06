import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import '../../data/models/mission_model.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';

class LocalMissionMapSection extends StatelessWidget {
  const LocalMissionMapSection({
    required this.currentPosition,
    required this.markers,
    required this.onMapCreated,
    required this.onLocateMe,
    this.onTapMap,
    this.selectedMission,
    this.circles = const {},
    super.key,
  });

  final LatLng currentPosition;
  final Set<Marker> markers;
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
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            if (selectedMission != null)
              Positioned(
                top: 77,
                left: 39,
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
    const cardWidth = 124.0;
    const cardHeight = 74.0;

    return Container(
      width: cardWidth,
      height: cardHeight,
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
        children: [
          Expanded(
            child: Row(
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
                    child: mission.photo != null
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mission.title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
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
                        style: const TextStyle(
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
                        style: const TextStyle(
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
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              // Handle see mission
            },
            child: Container(
              height: 18,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF4E9),
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Text(
                l10n.seeMission,
                style: const TextStyle(
                  color: PartnerUiColors.brand,
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
