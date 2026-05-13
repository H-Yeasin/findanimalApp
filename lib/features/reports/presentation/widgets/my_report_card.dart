import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/routing/route_names.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/reports/presentation/providers/report_form_provider.dart';
import 'package:hesteka_frontend/features/seek/data/models/report_model.dart';
import 'package:hesteka_frontend/features/seek/presentation/providers/seek_reports_provider.dart';

class MyReportCard extends ConsumerWidget {
  const MyReportCard({
    required this.report,
    required this.l10n,
    super.key,
  });

  final ReportModel report;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: report.images.isNotEmpty
                ? Image.network(
                    report.images[0].secureUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const _ReportImageFallback(),
                  )
                : const _ReportImageFallback(),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      report.animalName.toUpperCase(),
                      style: AppTextStyles.condensedSectionTitle.copyWith(
                        color: AppColors.red,
                        fontSize: 24,
                      ),
                    ),
                    if (report.status.toLowerCase() == 'found')
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBA4A22),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.found,
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        ref.read(reportFormProvider.notifier).populate(report);
                        context.push(RouteNames.reportCreateStep1);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit,
                            color: AppColors.textPrimary,
                            size: 10,
                          ),
                          const SizedBox(width: 1),
                          Text(
                            l10n.editMyReport,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _buildReportSummary(),
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFBA4A22),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SmallActionButton(
                      label: l10n.seeOnMap,
                      onTap: () => _openMap(context, ref),
                    ),
                    _SmallActionButton(
                      label: l10n.seeAnimalSheet(report.animalName),
                      onTap: () => context.push('/reports/${report.id}'),
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

  void _openMap(BuildContext context, WidgetRef ref) {
    ref.read(selectedSeekReportProvider.notifier).state = report;
    context.push(RouteNames.reports);
  }

  String _buildReportSummary() {
    final details = [
      _localizeAge(report.age),
      _localizeSpecies(report.species),
      report.breed.trim(),
      _localizeStatus(report.status),
    ].where((value) => value.isNotEmpty).toList();

    return details.join(' | ');
  }

  String _localizeSpecies(String value) {
    switch (value.trim().toLowerCase()) {
      case 'dog':
        return l10n.reportStep1Dog;
      case 'cat':
        return l10n.reportStep1Cat;
      case 'bird':
        return l10n.reportStep1Bird;
      case 'rabbit':
        return l10n.reportStep1Rabbit;
      case 'other':
        return l10n.reportStep1Other;
      default:
        return value;
    }
  }

  String _localizeAge(String value) {
    switch (value.trim().toLowerCase()) {
      case 'junior':
        return l10n.addAnimalAgeJunior;
      case 'adult':
        return l10n.addAnimalAgeAdult;
      case 'senior':
        return l10n.addAnimalAgeSenior;
      default:
        return value;
    }
  }

  String _localizeStatus(String value) {
    switch (value.trim().toLowerCase()) {
      case 'lost':
        return l10n.reportStep1Lost;
      case 'found':
        return l10n.reportStep1Found;
      case 'spotted':
        return l10n.reportStep1Spotted;
      case 'injured':
        return l10n.reportStep1Injured;
      default:
        return value;
    }
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFBA4A22),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _ReportImageFallback extends StatelessWidget {
  const _ReportImageFallback();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.cat,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 80,
        height: 80,
        color: Colors.grey[300],
        child: const Icon(Icons.pets),
      ),
    );
  }
}
