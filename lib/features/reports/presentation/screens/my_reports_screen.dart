import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/features/reports/presentation/providers/report_form_provider.dart';
import 'package:hesteka_frontend/features/seek/data/models/report_model.dart';
import 'package:hesteka_frontend/features/seek/presentation/providers/seek_reports_provider.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';
import '../providers/my_reports_provider.dart';

class MyReportsScreen extends ConsumerWidget {
  final bool showBottomNav;

  const MyReportsScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(myReportsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTopBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    child: Text(
                      l10n.myReportsTitle,
                      style: AppTextStyles.heading.copyWith(
                        color: AppColors.red,
                        fontSize: 32,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: reportsAsync.when(
                      data: (reports) => RefreshIndicator(
                        color: const Color(0xFFBA4A22),
                        onRefresh: () => ref.refresh(myReportsProvider.future),
                        child: reports.isEmpty
                            ? ListView(
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.6,
                                    child: Center(
                                      child: Text(
                                        l10n.noReportsYet,
                                        style: AppTextStyles.body.copyWith(
                                          color: Color(0xFFBA4A22),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                                itemCount: reports.length,
                                itemBuilder: (context, index) =>
                                    _buildReportCard(
                                      context,
                                      ref,
                                      reports[index],
                                      l10n,
                                    ),
                              ),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFBA4A22),
                        ),
                      ),
                      error: (err, stack) {
                        final errorText = err.toString().toLowerCase();
                        final isUnauthorized =
                            errorText.contains('401') ||
                            errorText.contains('unauthorized');

                        if (isUnauthorized) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l10n.pleaseLoginToViewReports,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.subtitle.copyWith(
                                      color: const Color(0xFFBA4A22),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () =>
                                        context.push(RouteNames.account),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFBA4A22),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(l10n.goToLogin),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Center(
                          child: Text(
                            l10n.couldNotLoadReports,
                            style: AppTextStyles.body.copyWith(
                              color: Color(0xFFBA4A22),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 35,
              bottom: 55,
              child: FloatingActionButton(
                onPressed: () {
                  ref.read(reportFormProvider.notifier).reset();
                  context.push(RouteNames.reportCreateStep1);
                },
                backgroundColor: AppColors.red,
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? CustomBottomNavigationBar(
              currentIndex: 1,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go(RouteNames.root);
                    break;
                  case 1:
                    break;
                  case 3:
                    context.go(RouteNames.mainCommunity);
                    break;
                  case 4:
                    context.go(RouteNames.mainSolidarity);
                    break;
                  case 2:
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(RouteNames.mainProfile);
                    }
                    break;
                }
              },
            )
          : null,
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    WidgetRef ref,
    ReportModel report,
    AppLocalizations l10n,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
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
                            _reportImageFallback(),
                      )
                    : _reportImageFallback(),
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
                        // if (report.status.toLowerCase() == 'found')
                        //   Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(left: 30),
                        //       child: Container(
                        //         padding: const EdgeInsets.symmetric(
                        //           horizontal: 12,
                        //           vertical: 4,
                        //         ),
                        //         decoration: BoxDecoration(
                        //           color: const Color(0xFFBA4A22),
                        //           borderRadius: BorderRadius.circular(15),
                        //         ),
                        //         child: Row(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             const Icon(
                        //               Icons.check,
                        //               color: Colors.white,
                        //               size: 14,
                        //             ),
                        //             const SizedBox(width: 4),
                        //             Text(
                        //               l10n.found,
                        //               style: AppTextStyles.button.copyWith(
                        //                 color: Colors.white,
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.w900,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(reportFormProvider.notifier)
                                .populate(report);
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
                      _buildReportSummary(report, l10n),
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
                        _buildSmallButton(
                          l10n.seeOnMap,
                          () => _openMap(context, ref, report),
                        ),
                        _buildSmallButton(
                          l10n.seeAnimalSheet(report.animalName),
                          () => context.push('/reports/${report.id}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reportImageFallback() {
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

  void _openMap(BuildContext context, WidgetRef ref, ReportModel report) {
    ref.read(selectedSeekReportProvider.notifier).state = report;
    context.push(RouteNames.reports);
  }

  String _buildReportSummary(ReportModel report, AppLocalizations l10n) {
    final details = [
      _localizeAge(report.age, l10n),
      _localizeSpecies(report.species, l10n),
      report.breed.trim(),
      _localizeStatus(report.status, l10n),
    ].where((value) => value.isNotEmpty).toList();

    return details.join(' | ');
  }

  String _localizeSpecies(String value, AppLocalizations l10n) {
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

  String _localizeAge(String value, AppLocalizations l10n) {
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

  String _localizeStatus(String value, AppLocalizations l10n) {
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

  Widget _buildSmallButton(String label, VoidCallback onTap) {
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
