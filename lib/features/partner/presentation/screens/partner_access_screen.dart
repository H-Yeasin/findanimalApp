import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../auth/data/models/auth_user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../../../core/localization/app_localizations.dart';

class PartnerAccessScreen extends ConsumerStatefulWidget {
  const PartnerAccessScreen({super.key});

  @override
  ConsumerState<PartnerAccessScreen> createState() =>
      _PartnerAccessScreenState();
}

class _PartnerAccessScreenState extends ConsumerState<PartnerAccessScreen> {
  bool _notificationsEnabled = true;

  Future<void> _openMyAdsDrawer(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(18, 0, 18, 50),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: PartnerUiColors.panel,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: PartnerUiColors.brand),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.myAdsTitle,
                  style: AppTextStyles.condensedSectionTitle.copyWith(
                    color: PartnerUiColors.brand,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                _MyAdsDrawerActionCard(
                  icon: Icons.location_on_rounded,
                  label: l10n.collectionPoints,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push(RouteNames.partnerCollectionPoints);
                  },
                ),
                const Divider(color: PartnerUiColors.brand),
                _MyAdsDrawerActionCard(
                  icon: Icons.flag_outlined,
                  label: l10n.categoryMissions,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push(RouteNames.partnerMissions);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);

    return PartnerScreenScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 34),
            const AppTopBar(showUserAvatar: false),
            const SizedBox(height: 14),
            if (user != null) _buildPartnerDashboard(context, user, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerDashboard(
    BuildContext context,
    AuthUserModel user,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          user.company?.toUpperCase() ?? l10n.partnerLabel,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading.copyWith(
            color: PartnerUiColors.brand,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.welcomeName(user.firstName),
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.brandSecondary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          constraints: const BoxConstraints(minHeight: 390),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: PartnerUiColors.panel,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: PartnerUiColors.brand, width: 1),
          ),
          child: Column(
            children: [
              PartnerCardActionRow(
                icon: Icons.person,
                label: l10n.myProfile,
                onTap: () => context.push(RouteNames.partnerProfile),
              ),
              const Divider(color: PartnerUiColors.brand),
              PartnerCardActionRow(
                icon: Icons.campaign_outlined,
                label: l10n.myAds,
                onTap: () => _openMyAdsDrawer(context),
              ),
              const Divider(color: PartnerUiColors.brand),
              PartnerCardActionRow(
                icon: Icons.settings,
                label: l10n.settings,
                onTap: () => context.push(RouteNames.partnerSettings),
              ),
              const Divider(color: PartnerUiColors.brand),
              PartnerCardActionRow(
                icon: Icons.notifications_none_rounded,
                label: l10n.notifications,
                trailing: PartnerToggle(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _notificationsEnabled = !_notificationsEnabled;
                  });
                },
              ),
              const Divider(color: PartnerUiColors.brand),
              const SizedBox(height: 30),
              PartnerCardActionRow(
                icon: Icons.logout,
                label: l10n.logout.toUpperCase(),
                onTap: () async {
                  await ref.read(authSessionProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(RouteNames.account);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MyAdsDrawerActionCard extends StatelessWidget {
  const _MyAdsDrawerActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 66,
        child: Row(
          children: [
            Icon(icon, color: PartnerUiColors.brand, size: 28),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.condensedSectionTitle.copyWith(
                  color: PartnerUiColors.brand,
                  fontSize: 38 / 2,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: PartnerUiColors.brand,
              size: 36,
            ),
          ],
        ),
      ),
    );
  }
}
