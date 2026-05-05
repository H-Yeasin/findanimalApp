import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';

class PartnerProfileScreen extends ConsumerWidget {
  const PartnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(myProfileProvider);

    // Get hero image from the API profile (has profileImage.secure_url)
    // Fall back to session user data, then empty string (grey placeholder)
    final heroImage = profileAsync.maybeWhen(
      data: (profile) => profile.profileImage?.secure_url ?? '',
      orElse: () =>
          (user?.profileImage?.isNotEmpty ?? false) ? user!.profileImage! : '',
    );

    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: l10n.personalInformation,
        imageUrl: heroImage,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(38, 18, 38, 28),
        child: Column(
          children: [
            Text(
              l10n.myInformation,
              style: const TextStyle(
                color: Color(0xFFD8C89D),
                fontFamily: 'EricaOne',
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            PartnerInfoRow(
              label: l10n.firstName.toUpperCase(),
              value: user?.firstName ?? '',
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(
              label: l10n.lastName.toUpperCase(),
              value: user?.lastName ?? '',
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(
              label: l10n.company.toUpperCase(),
              value: user?.company ?? '',
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(
              label: l10n.email.toUpperCase(),
              value: user?.email ?? '',
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(
              label: l10n.phone.toUpperCase(),
              value: user?.phone ?? l10n.noPhone,
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerInfoRow(
              label: l10n.address.toUpperCase(),
              value: user?.address ?? l10n.unknownValue,
              compact: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 280,
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
                    fontSize: 14,
                  ),
                ),
                onPressed: () =>
                    context.push(RouteNames.profilePersonalInformation),
                child: Text(l10n.editMyInformation),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
