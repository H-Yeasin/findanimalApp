import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class PartnerProfileScreen extends ConsumerStatefulWidget {
  const PartnerProfileScreen({super.key});

  @override
  ConsumerState<PartnerProfileScreen> createState() =>
      _PartnerProfileScreenState();
}

class _PartnerProfileScreenState extends ConsumerState<PartnerProfileScreen> {
  String? _currentHeroImageUrl;

  void _syncHeroImage(ProfileModel profile) {
    final imageUrl = profile.profileImage?.secure_url;
    if (_currentHeroImageUrl == imageUrl) return;
    _currentHeroImageUrl = imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(myProfileProvider);
    final imageCacheBuster = ref.watch(profileImageCacheBusterProvider);
    final profile = profileAsync.valueOrNull;
    if (profile != null) {
      _syncHeroImage(profile);
    }

    final heroImage = profileImageUrlWithCacheBuster(
      _currentHeroImageUrl ?? profile?.profileImage?.secure_url,
      imageCacheBuster,
    );

    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: l10n.personalInformation,
        imageUrl: heroImage ?? '',
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(38, 18, 38, 28),
        child: profileAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.only(top: 36),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.only(top: 36),
            child: Text(
              l10n.errorParam(error.toString()),
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: PartnerUiColors.brand,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          data: (profile) {
            final addressParts = [
              profile.address,
              profile.postalCode,
              profile.city,
              profile.country,
            ].whereType<String>();
            final fullAddress = addressParts
                .where((part) => part.trim().isNotEmpty)
                .join(', ');
            final locationAddress = profile.location?.address;

            return Column(
              children: [
                Text(
                  l10n.myInformation,
                  style: AppTextStyles.body.copyWith(
                    color: Color(0xFFD8C89D),
                    fontFamily: 'EricaOne',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                PartnerInfoRow(
                  label: l10n.company.toUpperCase(),
                  value: profile.company ?? l10n.unknownValue,
                ),
                const Divider(color: PartnerUiColors.brand),
                PartnerInfoRow(
                  label: l10n.firstName.toUpperCase(),
                  value: profile.firstName,
                ),
                const Divider(color: PartnerUiColors.brand),
                PartnerInfoRow(
                  label: l10n.lastName.toUpperCase(),
                  value: profile.lastName,
                ),
                const Divider(color: PartnerUiColors.brand),
                PartnerInfoRow(
                  label: l10n.email.toUpperCase(),
                  value: profile.email,
                ),
                const Divider(color: PartnerUiColors.brand),
                PartnerInfoRow(
                  label: l10n.phone.toUpperCase(),
                  value: profile.phone.isNotEmpty
                      ? profile.phone
                      : l10n.noPhone,
                ),
                const Divider(color: PartnerUiColors.brand),
                PartnerInfoRow(
                  label: l10n.address.toUpperCase(),
                  value: fullAddress.isNotEmpty
                      ? fullAddress
                      : l10n.unknownValue,
                  compact: true,
                ),
                if (locationAddress != null &&
                    locationAddress.trim().isNotEmpty) ...[
                  const Divider(color: PartnerUiColors.brand),
                  PartnerInfoRow(
                    label: l10n.locationAddress.toUpperCase(),
                    value: locationAddress,
                    compact: true,
                  ),
                ],
                if (profile.website != null &&
                    profile.website!.trim().isNotEmpty) ...[
                  const Divider(color: PartnerUiColors.brand),
                  PartnerInfoRow(
                    label: 'WEBSITE',
                    value: profile.website!,
                    compact: true,
                  ),
                ],
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
                      textStyle: AppTextStyles.body.copyWith(
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
            );
          },
        ),
      ),
    );
  }
}
