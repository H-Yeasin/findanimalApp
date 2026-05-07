import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/repositories/missions_repository_impl.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

final missionParticipantsProvider =
    FutureProvider.family<List<dynamic>, String>((ref, missionId) {
      return ref
          .watch(missionsRepositoryProvider)
          .getLocalMissionParticipants(missionId);
    });

class MissionParticipantsBottomSheet extends ConsumerWidget {
  const MissionParticipantsBottomSheet({required this.missionId, super.key});

  final String missionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync = ref.watch(missionParticipantsProvider(missionId));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PartnerUiColors.brand.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Participants',
                style: AppTextStyles.body.copyWith(
                  color: PartnerUiColors.brand,
                  fontFamily: 'EricaOne',
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: participantsAsync.when(
                  data: (participants) {
                    if (participants.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucun participant pour le moment',
                          style: AppTextStyles.body.copyWith(
                            color: PartnerUiColors.brand.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: scrollController,
                      itemCount: participants.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final participant =
                            participants[index] as Map<String, dynamic>;
                        final user =
                            participant['user'] as Map<String, dynamic>;
                        final firstName = user['firstName'] ?? '';
                        final lastName = user['lastName'] ?? '';
                        final email = user['email'] ?? '';
                        final status = participant['status'] ?? '';
                        final points = participant['pointsAwarded'] ?? 0;

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: PartnerUiColors.brand.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: PartnerUiColors.brand,
                                child: Text(
                                  firstName.isNotEmpty
                                      ? firstName[0].toUpperCase()
                                      : '?',
                                  style: AppTextStyles.body.copyWith(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$firstName $lastName',
                                      style: AppTextStyles.body.copyWith(
                                        color: PartnerUiColors.brand,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      email,
                                      style: AppTextStyles.body.copyWith(
                                        color: PartnerUiColors.brand.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        status,
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: AppTextStyles.body.copyWith(
                                        color: _getStatusColor(status),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (points > 0)
                                    Text(
                                      '+$points pts',
                                      style: AppTextStyles.body.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: PartnerUiColors.brand,
                    ),
                  ),
                  error: (error, _) => Center(child: Text('Erreur: $error')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return PartnerUiColors.brand;
    }
  }
}
