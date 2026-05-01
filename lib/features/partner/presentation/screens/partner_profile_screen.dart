import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';

class PartnerProfileScreen extends ConsumerWidget {
  const PartnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final heroImage = (user?.profileImage?.isNotEmpty ?? false)
        ? user!.profileImage!
        : '';

    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: 'PERSONAL\nINFORMATION',
        imageUrl: heroImage,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(38, 18, 38, 28),
        child: Column(
          children: [
            const Text(
              'My information',
              style: TextStyle(
                color: Color(0xFFD8C89D),
                fontFamily: 'EricaOne',
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            PartnerInfoRow(label: 'FIRST NAME', value: user?.firstName ?? ''),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(label: 'LAST NAME', value: user?.lastName ?? ''),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(label: 'COMPANY', value: user?.company ?? ''),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(label: 'E-MAIL', value: user?.email ?? ''),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(label: 'PHONE', value: user?.phone ?? 'N/A'),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(
              label: 'ADDRESS',
              value: user?.address ?? 'N/A',
              compact: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 220,
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PartnerUiColors.brand,
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
                    context.push(RouteNames.profilePersonalInformation),
                child: const Text('Edit information'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
