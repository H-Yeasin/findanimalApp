import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../seek/presentation/widgets/seek_reports_list.dart';
import '../providers/home_providers.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class HomeReportedRecentlySection extends ConsumerWidget {
  const HomeReportedRecentlySection({super.key, required this.onOpenReports});

  final VoidCallback onOpenReports;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            l10n.homeReportedRecently,
            style: AppTextStyles.body.copyWith(
              color: Color(0xFFBA4A22),
              fontSize: 28,
              fontWeight: FontWeight.w900,
              fontFamily: 'EricaOne',
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            l10n.homeNearYou,
            style: AppTextStyles.body.copyWith(
              color: Color(0xFFBA4A22),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 25),
          ref
              .watch(homeReportsProvider)
              .when(
                data: (reports) {
                  if (reports.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noReportsFound,
                        style: AppTextStyles.body.copyWith(color: Color(0xFFBA4A22)),
                      ),
                    );
                  }

                  final recentReports = reports.take(3);

                  return Column(
                    children: recentReports
                        .map(
                          (report) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SeekAnimalCard(
                              report: report,
                              onViewOnMap: () {
                                ref.read(selectedHomeReportProvider.notifier).state = report;
                              },
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
                ),
                error: (error, stack) =>
                    Center(child: Text('${l10n.errorLoadingReports} $error')),
              ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: onOpenReports,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFBA4A22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.homeSeeMore,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
