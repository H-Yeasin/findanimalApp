import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/routing/route_names.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/reports/presentation/providers/my_reports_provider.dart';
import 'package:hesteka_frontend/features/reports/presentation/widgets/my_report_card.dart';

class MyReportsContent extends ConsumerWidget {
  const MyReportsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(myReportsProvider);
    final l10n = AppLocalizations.of(context);

    return reportsAsync.when(
      data: (reports) => RefreshIndicator(
        color: const Color(0xFFBA4A22),
        onRefresh: () => ref.refresh(myReportsProvider.future),
        child: reports.isEmpty
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Text(
                        l10n.noReportsYet,
                        style: AppTextStyles.body.copyWith(
                          color: const Color(0xFFBA4A22),
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
                itemBuilder: (context, index) => MyReportCard(
                  report: reports[index],
                  l10n: l10n,
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
        final isUnauthorized = errorText.contains('401') ||
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
                    style: AppTextStyles.subtitle.copyWith(
                      color: const Color(0xFFBA4A22),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.push(RouteNames.account),
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
              color: const Color(0xFFBA4A22),
            ),
          ),
        );
      },
    );
  }
}
