import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../features/partner/presentation/widgets/partner_ui_kit.dart';
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

    return AppBackgroundScaffold(
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
      body: AppBackground(
        showGridFromTop: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 70),
              AppTopBar(
                showBackButton: true,
                showUserAvatar: false,
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(RouteNames.myProfile);
                  }
                },
              ),
              const SizedBox(height: 18),
              Text(
                l10n.myProfile,
                style: AppTextStyles.heading.copyWith(
                  color: PartnerUiColors.brand,
                ),
              ),
              const SizedBox(height: 14),
              profileAsync.when(
                loading: () => _personalInfoCard(
                  l10n: l10n,
                  name: '...',
                  onTap: () =>
                      context.push(RouteNames.profilePersonalInformation),
                ),
                error: (error, stack) => _personalInfoCard(
                  l10n: l10n,
                  name: currentUser?.fullName.isNotEmpty == true
                      ? currentUser!.fullName
                      : l10n.myProfile,
                  onTap: () =>
                      context.push(RouteNames.profilePersonalInformation),
                ),
                data: (profile) => _personalInfoCard(
                  l10n: l10n,
                  name:
                      '${profile.firstName} ${profile.lastName}'.trim().isEmpty
                      ? l10n.myProfile
                      : '${profile.firstName} ${profile.lastName}'.trim(),
                  onTap: () =>
                      context.push(RouteNames.profilePersonalInformation),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.myAnimals,
                      style: AppTextStyles.heading.copyWith(
                        color: PartnerUiColors.brand,
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
                        color: PartnerUiColors.brand,
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
                      color: PartnerUiColors.brand,
                    ),
                  ),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Text(
                        l10n.couldNotLoadAnimals(error.toString()),
                        style: AppTextStyles.body.copyWith(
                          color: PartnerUiColors.brand,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => ref.invalidate(myAnimalsProvider),
                        child: Text(l10n.retry),
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        l10n.noAnimalsYet,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: PartnerUiColors.brand,
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
                      backgroundColor: PartnerUiColors.brand,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    onPressed: () => context.push(RouteNames.reportCreateStep1),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        l10n.reportOneOfMyAnimals,
                        maxLines: 1,
                        softWrap: false,
                        style: AppTextStyles.button.copyWith(
                          fontFamily: AppTextStyles.titleFont,
                          fontSize: 18,
                        ),
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

  Widget _personalInfoCard({
    required AppLocalizations l10n,
    required String name,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: PartnerUiColors.brand,
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
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.personalInformationLabel,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: const Color(0xFFF3DCC8),
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
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 10),
      decoration: BoxDecoration(
        color: PartnerUiColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PartnerUiColors.brand, width: 1),
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
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: PartnerUiColors.brand,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onEdit,
                      child: Text(
                        l10n.edit,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: const Color(0xFFD8C89D),
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
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: PartnerUiColors.brand,
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
        color: PartnerUiColors.grid,
      ),
      child: const Icon(Icons.pets, color: PartnerUiColors.brand),
    );
  }
}
