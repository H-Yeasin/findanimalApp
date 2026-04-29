import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/features/reports/presentation/providers/report_form_provider.dart';
import 'package:hesteka_frontend/features/seek/data/models/report_model.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../providers/my_reports_provider.dart';
import '../widgets/report_base_layout.dart';

class MyReportsScreen extends ConsumerWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(myReportsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: GridBackgroundPainter())),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppTopBar(showBackButton: false),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: Text(
                    l10n.myReportsTitle,
                    style: const TextStyle(
                      color: Color(0xFFBA4A22),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Impact',
                    ),
                  ),
                ),
                Expanded(
                  child: reportsAsync.when(
                    data: (reports) => ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      itemCount: reports.length,
                      itemBuilder: (context, index) =>
                          _buildReportCard(context, ref, reports[index], l10n),
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
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.pleaseLoginToViewReports,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFFBA4A22),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
                          style: const TextStyle(color: Color(0xFFBA4A22)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                ref.read(reportFormProvider.notifier).reset();
                context.push(RouteNames.reportCreateStep1);
              },
              backgroundColor: const Color(0xFFBA4A22),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
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
                child: Image.network(
                  report.images.isNotEmpty == true
                      ? report.images[0].secureUrl
                      : 'https://via.placeholder.com/100',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.pets),
                  ),
                ),
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
                          style: const TextStyle(
                            color: Color(0xFFBA4A22),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Impact',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(reportFormProvider.notifier)
                                .populate(report);
                            context.push(RouteNames.reportCreateStep1);
                          },
                          child: Text(
                            l10n.editMyReport,
                            style: const TextStyle(
                              color: Color(0xFFBA4A22),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${report.age} | . ${report.species} | . ${report.breed} | . ${report.status}',
                      style: const TextStyle(
                        color: Color(0xFFBA4A22),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSmallButton(l10n.seeOnMap, () {}),
                        _buildSmallButton(
                          l10n.seeAnimalSheet(report.animalName),
                          () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (report.status.toLowerCase() == 'found')
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 95),
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
                      const Icon(Icons.check, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        l10n.found,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
