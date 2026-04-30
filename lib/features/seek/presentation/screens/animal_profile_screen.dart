import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/animal_profile/animal_profile_data.dart';
import '../widgets/animal_profile/animal_profile_grid_painter.dart';
import '../widgets/animal_profile/animal_profile_header.dart';
import '../widgets/animal_profile/animal_profile_card.dart';
import '../widgets/animal_profile/animal_profile_map_section.dart';
import '../widgets/animal_profile/animal_profile_comments_section.dart';

// Re-export AnimalProfileData so files importing this screen for data still work
export '../widgets/animal_profile/animal_profile_data.dart';

class AnimalProfileScreen extends ConsumerWidget {
  final AnimalProfileData data;

  const AnimalProfileScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6ED),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: AnimalProfileGridPainter())),
          SafeArea(
            child: Column(
              children: [
                const AnimalProfileHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        children: [
                          // === OUTER WRAPPER CARD ===
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5E4CE),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFBA4A22),
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AnimalProfileCard(data: data),
                                  AnimalProfileMapSection(data: data),
                                  AnimalProfileCommentsSection(data: data),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
