import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/home_providers.dart';

class HomeCommunityHelpedSection extends ConsumerWidget {
  const HomeCommunityHelpedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statsAsync = ref.watch(homeStatsProvider);

    return Container(
      width: double.infinity,
      color: const Color(0xFFAB4523),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Text(
            l10n.homeCommunityHelped,
            style: AppTextStyles.body.copyWith(
              color: Color(0xFFF9EAD4),
              fontSize: 32,
              fontFamily: 'EricaOne',
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          statsAsync.when(
            data: (stats) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCircle(
                  number: stats['ANIMALS FOUND'] ?? '0',
                  label: l10n.homeAnimalsFound,
                ),
                _StatCircle(
                  number: stats['REPORTS'] ?? '0',
                  label: l10n.homeReports,
                ),
                _StatCircle(
                  number: stats['ANIMALS RESCUED'] ?? '0',
                  label: l10n.homeAnimalsRescued,
                ),
              ],
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFFF9EAD4)),
            ),
            error: (error, stack) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCircle(number: '0', label: l10n.homeAnimalsFound),
                _StatCircle(number: '0', label: l10n.homeReports),
                _StatCircle(number: '0', label: l10n.homeAnimalsRescued),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCircle extends StatelessWidget {
  const _StatCircle({required this.number, required this.label});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF9EAD4), width: 1.5),
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.heading.copyWith(color: Color(0xFFF9EAD4)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: Color(0xFFF9EAD4),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
