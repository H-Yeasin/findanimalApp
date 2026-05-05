import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';
import '../../data/models/my_animal_model.dart';
import '../providers/my_animals_provider.dart';
import '../providers/profile_providers.dart';

class MyAnimalsScreen extends ConsumerStatefulWidget {
  const MyAnimalsScreen({super.key});

  @override
  ConsumerState<MyAnimalsScreen> createState() => _MyAnimalsScreenState();
}

class _MyAnimalsScreenState extends ConsumerState<MyAnimalsScreen> {
  Future<void> _openAddAnimal() async {
    await context.push(RouteNames.profileAddAnimal);
    ref.invalidate(myAnimalsProvider);
  }

  Future<void> _openEditAnimal(MyAnimalModel animal) async {
    await context.push(
      RouteNames.profileEditAnimal.replaceFirst(':id', animal.id),
      extra: animal,
    );
    ref.invalidate(myAnimalsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(myProfileProvider);
    final animalsAsync = ref.watch(myAnimalsProvider);
    final currentUser = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(RouteNames.myProfile);
                        }
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 43,
                        height: 43,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFBA4A22),
                        ),
                        child: const Icon(
                          Icons.undo,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'My profile',
                    style: TextStyle(
                      color: Color(0xFFBA4A22),
                      fontFamily: 'EricaOne',
                      fontSize: 30,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 14),
                  profileAsync.when(
                    loading: () => _personalInfoCard(
                      name: 'Loading...',
                      onTap: () =>
                          context.push(RouteNames.profilePersonalInformation),
                    ),
                    error: (error, stack) => _personalInfoCard(
                      name: currentUser?.fullName.isNotEmpty == true
                          ? currentUser!.fullName
                          : 'My profile',
                      onTap: () =>
                          context.push(RouteNames.profilePersonalInformation),
                    ),
                    data: (profile) => _personalInfoCard(
                      name:
                          '${profile.firstName} ${profile.lastName}'
                              .trim()
                              .isEmpty
                          ? 'My profile'
                          : '${profile.firstName} ${profile.lastName}'.trim(),
                      onTap: () =>
                          context.push(RouteNames.profilePersonalInformation),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'My animals',
                          style: TextStyle(
                            color: Color(0xFFBA4A22),
                            fontFamily: 'EricaOne',
                            fontSize: 30,
                            height: 1.0,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _openAddAnimal,
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFBA4A22),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  animalsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFBA4A22),
                        ),
                      ),
                    ),
                    error: (error, stack) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          Text(
                            'Could not load animals: $error',
                            style: const TextStyle(
                              color: Color(0xFFBA4A22),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () => ref.invalidate(myAnimalsProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                    data: (animals) {
                      final ownerId = currentUser?.id;
                      final myAnimals = ownerId == null
                          ? animals
                          : animals
                                .where(
                                  (animal) =>
                                      animal.user?.id.isNotEmpty == true &&
                                      animal.user!.id == ownerId,
                                )
                                .toList();

                      if (myAnimals.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'No animals added yet. Tap + to add your first one.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFBA4A22),
                              fontFamily: 'EricaOne',
                              fontSize: 18,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myAnimals.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final animal = myAnimals[index];
                          return _AnimalCard(
                            animal: animal,
                            onEdit: () => _openEditAnimal(animal),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                  Center(
                    child: SizedBox(
                      width: 340,
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBA4A22),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'EricaOne',
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () =>
                            context.push(RouteNames.reportCreateStep1),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.reportOneOfMyAnimals,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.root);
              break;
            case 1:
              context.go(RouteNames.reports);
              break;
            case 3:
              context.go(RouteNames.mainCommunity);
              break;
            case 4:
              context.go(RouteNames.mainSolidarity);
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }

  Widget _personalInfoCard({
    required String name,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFBA4A22),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'EricaOne',
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Personal information',
                    style: TextStyle(
                      color: Color(0xFFF3DCC8),
                      fontFamily: 'EricaOne',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 36,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimalCard extends StatelessWidget {
  const _AnimalCard({required this.animal, required this.onEdit});

  final MyAnimalModel animal;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFE8D5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: animal.photo?.secureUrl.isNotEmpty == true
                ? Image.network(
                    animal.photo!.secureUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _placeholderImage(),
                  )
                : _placeholderImage(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        animal.title,
                        style: const TextStyle(
                          color: Color(0xFFBA4A22),
                          fontFamily: 'EricaOne',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onEdit,
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: Color(0xFFD8C89D),
                          fontFamily: 'EricaOne',
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  animal.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFBA4A22),
                    fontFamily: 'EricaOne',
                    fontSize: 14,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFE7DCCB),
      ),
      child: const Icon(Icons.pets, color: Color(0xFFBA4A22)),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE7DCCB)
      ..strokeWidth = 1;

    const xStep = 92.0;
    const yStep = 102.0;

    for (double x = 0; x <= size.width; x += xStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += yStep) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
