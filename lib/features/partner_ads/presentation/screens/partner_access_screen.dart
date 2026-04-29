import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../auth/data/models/auth_user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/partner_ui_kit.dart';

class PartnerAccessScreen extends ConsumerStatefulWidget {
  const PartnerAccessScreen({super.key});

  @override
  ConsumerState<PartnerAccessScreen> createState() =>
      _PartnerAccessScreenState();
}

class _PartnerAccessScreenState extends ConsumerState<PartnerAccessScreen> {
  bool _notificationsEnabled = true;

  Future<void> _openMyAdsDrawer(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: PartnerUiColors.panel,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: PartnerUiColors.brand),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'MY ADS',
                  style: TextStyle(
                    color: PartnerUiColors.brand,
                    fontFamily: 'Impact',
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                PartnerCardActionRow(
                  icon: Icons.location_on_rounded,
                  label: 'Collection points',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push(RouteNames.partnerCollectionPoints);
                  },
                ),
                const Divider(color: PartnerUiColors.brand),
                PartnerCardActionRow(
                  icon: Icons.flag_outlined,
                  label: 'Missions',
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
    final user = ref.watch(currentUserProvider);
    final isPartner = user?.role == 'partners';

    return PartnerScreenScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTopBar(),
            const SizedBox(height: 14),
            if (isPartner) ...[
              _buildPartnerDashboard(context, user!),
            ] else ...[
              _buildPartnerAuthGateway(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerAuthGateway(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'HESTEKA PARTNER',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: PartnerUiColors.brand,
            fontFamily: 'Impact',
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Join the network of professionals dedicated to animal welfare.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF1F2D58), fontSize: 16),
        ),
        const SizedBox(height: 60),
        SizedBox(
          width: 220,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PartnerUiColors.brand,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => context.push(RouteNames.partnerLogin),
            child: const Text(
              'LOG IN AS PARTNER',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 220,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: PartnerUiColors.brand,
              side: const BorderSide(color: PartnerUiColors.brand, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => context.push(RouteNames.partnerRegister),
            child: const Text(
              'REGISTER AS PARTNER',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPartnerDashboard(BuildContext context, AuthUserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          user.company?.toUpperCase() ?? 'PARTNER',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: PartnerUiColors.brand,
            fontFamily: 'Impact',
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome, ${user.firstName}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF1F2D58),
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
                label: 'My profile',
                onTap: () => context.push(RouteNames.partnerProfile),
              ),
              const Divider(color: PartnerUiColors.brand),
              PartnerCardActionRow(
                icon: Icons.campaign_outlined,
                label: 'My ads',
                onTap: () => _openMyAdsDrawer(context),
              ),
              const Divider(color: PartnerUiColors.brand),
              PartnerCardActionRow(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () => context.push(RouteNames.partnerSettings),
              ),
              const Divider(color: PartnerUiColors.brand),
              PartnerCardActionRow(
                icon: Icons.notifications_none_rounded,
                label: 'Notifications',
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
                label: 'LOGOUT',
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
