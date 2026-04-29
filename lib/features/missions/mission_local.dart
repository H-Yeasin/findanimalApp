import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/models/mission_model.dart';
import 'presentation/providers/missions_list_provider.dart';

class MissionLocalScreen extends ConsumerStatefulWidget {
  const MissionLocalScreen({super.key});

  @override
  ConsumerState<MissionLocalScreen> createState() => _MissionLocalScreenState();
}

class _MissionLocalScreenState extends ConsumerState<MissionLocalScreen> {
  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFFBA4A22);
    const surface = Color(0xFFFBF4E9);
    final missionsAsync = ref.watch(missionsListProvider);

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: brandPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/Login_signup/account.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'MISSIONS\nLOCALES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: brandPrimary,
                        height: 0.9,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Inscris-toi dans une mission locale, accomplis des missions solidaires et gagne des points en faisant avancer de vraies causes !',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: brandPrimary),
                    ),
                  ],
                ),
              ),

              // Map Section
              Container(
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Map/map.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Text('Map Image')),
                      ),
                    ),
                    // Red circle overlay
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: brandPrimary, width: 2),
                      ),
                    ),
                    // Mock markers
                    const Positioned(
                      top: 100,
                      left: 100,
                      child: Icon(
                        Icons.location_on,
                        color: brandPrimary,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),

              // Filters Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildFilterButton(
                        'TRIER PAR',
                        Icons.keyboard_arrow_down,
                        brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: _buildFilterButton(
                        'PÉLISSANNE (13330) - 5KM',
                        Icons.keyboard_arrow_down,
                        brandPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Missions List
              missionsAsync.when(
                data: (paginatedData) {
                  final missions = paginatedData.data;
                  if (missions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        'Aucune mission trouvée pour le moment.',
                        style: TextStyle(
                          color: brandPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: missions.length,
                    itemBuilder: (context, index) => _MissionCard(
                      mission: missions[index],
                      brandPrimary: brandPrimary,
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: brandPrimary),
                ),
                error: (error, stack) => Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    'Erreur: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

              // Pagination
              missionsAsync.maybeWhen(
                data: (paginatedData) {
                  if (paginatedData.totalPages <= 1) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            color: brandPrimary,
                          ),
                          onPressed: paginatedData.page > 1
                              ? () => ref
                                    .read(missionsListProvider.notifier)
                                    .goToPage(paginatedData.page - 1)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        for (int i = 1; i <= paginatedData.totalPages; i++)
                          _buildPageNumber(
                            i.toString(),
                            brandPrimary,
                            active: i == paginatedData.page,
                            onTap: () {
                              if (i != paginatedData.page) {
                                ref
                                    .read(missionsListProvider.notifier)
                                    .goToPage(i);
                              }
                            },
                          ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_right,
                            color: brandPrimary,
                          ),
                          onPressed:
                              paginatedData.page < paginatedData.totalPages
                              ? () => ref
                                    .read(missionsListProvider.notifier)
                                    .goToPage(paginatedData.page + 1)
                              : null,
                        ),
                      ],
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(
                height: 100,
              ), // Extra space for the bottom nav overlap
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, IconData icon, Color brandPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: brandPrimary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(icon, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildPageNumber(
    String number,
    Color brandPrimary, {
    bool active = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          number,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: brandPrimary,
            decoration: active ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.mission, required this.brandPrimary});

  final MissionModel mission;
  final Color brandPrimary;

  @override
  Widget build(BuildContext context) {
    final organization = mission.partner?.company ?? 'Organisation';
    final timeAgo = mission.createdAt != null
        ? _formatTimeAgo(mission.createdAt!)
        : 'Récemment';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: brandPrimary.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: mission.photo != null
                  ? Image.network(
                      mission.photo!.secureUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          mission.title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: brandPrimary,
                          ),
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.brown.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$organization | Mission de ${mission.duration}',
                    style: TextStyle(
                      fontSize: 12,
                      color: brandPrimary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: brandPrimary,
                            side: BorderSide(color: brandPrimary),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'VOIR SUR LA CARTE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'VOIR LA MISSION',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) {
      return 'Il y a ${duration.inDays} j';
    } else if (duration.inHours > 0) {
      return 'Il y a ${duration.inHours} h';
    } else if (duration.inMinutes > 0) {
      return 'Il y a ${duration.inMinutes} m';
    } else {
      return 'À l\'instant';
    }
  }
}
