import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/report_model.dart';
import '../providers/seek_reports_provider.dart';
import 'animal_profile/animal_profile_data.dart';

class SeekReportsList extends ConsumerWidget {
  const SeekReportsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reportsAsync = ref.watch(seekReportsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: reportsAsync.when(
        data: (paginatedData) {
          final reports = paginatedData.data;
          if (reports.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  l10n.noReportsFound,
                  style: AppTextStyles.body.copyWith(
                    color: Color(0xFFBA4A22),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: reports.map((report) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SeekAnimalCard(
                  report: report,
                  onViewOnMap: () {
                    ref.read(selectedSeekReportProvider.notifier).state =
                        report;
                  },
                ),
              );
            }).toList(),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
          ),
        ),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              l10n.errorLoadingReports,
              style: AppTextStyles.body.copyWith(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class SeekAnimalCard extends StatelessWidget {
  const SeekAnimalCard({required this.report, this.onViewOnMap, super.key});

  final ReportModel report;
  final VoidCallback? onViewOnMap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final data = AnimalProfileData.fromReport(report);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 98,
            decoration: BoxDecoration(
              color: data.isPlaceholder ? const Color(0xFFFBF4E9) : null,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFBA4A22), width: 1.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: data.isPlaceholder
                  ? const Center(
                      child: Icon(
                        Icons.pets,
                        color: Color(0xFFBA4A22),
                        size: 40,
                      ),
                    )
                  : Image.network(
                      data.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[200]),
                    ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data.name,
                        style: AppTextStyles.condensedSectionTitle.copyWith(
                          fontSize: 26,
                          height: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      data.time,
                      style: AppTextStyles.caption.copyWith(
                        color: Color(0xFFD3A482),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -2),
                  child: Text(
                    data.details,
                    style: AppTextStyles.body.copyWith(
                      color: const Color(0xFFBA4A22),
                      fontSize: 20,
                      height: 1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SeekSmallButton(
                        text: l10n.viewOnMap,
                        isFilled: false,
                        onTap: onViewOnMap,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SeekSmallButton(
                        text: l10n.viewProfile(data.name.toUpperCase()),
                        isFilled: true,
                        onTap: () => context.push('/reports/${report.id}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SeekSmallButton extends StatelessWidget {
  const SeekSmallButton({
    required this.text,
    required this.isFilled,
    this.onTap,
    super.key,
  });

  final String text;
  final bool isFilled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isFilled ? const Color(0xFFBA4A22) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFBA4A22), width: 1.4),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: isFilled ? Colors.white : const Color(0xFFBA4A22),
              fontSize: 14,
              height: 1,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}
