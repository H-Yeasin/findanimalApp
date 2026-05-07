import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../Community/presentation/providers/contact_providers.dart';

class HubPartnersSection extends ConsumerWidget {
  final AppLocalizations l10n;

  const HubPartnersSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const brandPrimary = Color(0xFFBA4A22);

    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          l10n.thoseWhoAre,
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            color: brandPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          l10n.byOurSide,
          style: AppTextStyles.heading.copyWith(fontSize: 42),
        ),
        const SizedBox(height: 20),
        ref.watch(partnersProvider).when(
              data: (partners) {
                final validPartners = partners
                    .where(
                      (p) =>
                          p.fullImageUrl != null && p.fullImageUrl!.isNotEmpty,
                    )
                    .toList();
                if (validPartners.isEmpty) return const SizedBox();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: validPartners
                        .map(
                          (p) => _buildPartnerLogo(
                            p.fullImageUrl!,
                            brandPrimary,
                          ),
                        )
                        .toList(),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => const SizedBox(),
            ),
      ],
    );
  }

  Widget _buildPartnerLogo(String imageUrl, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: 90,
      height: 60,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.store, color: color, size: 30),
      ),
    );
  }
}
