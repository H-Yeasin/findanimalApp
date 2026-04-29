import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/paginated_response.dart';
import '../../data/models/report_model.dart';
import '../../data/repositories/reports_repository_impl.dart';

import 'seek_report_filters_provider.dart';

final seekReportsProvider = AsyncNotifierProvider<SeekReportsNotifier, PaginatedResponse<ReportModel>>(
  SeekReportsNotifier.new,
);

class SeekReportsNotifier extends AsyncNotifier<PaginatedResponse<ReportModel>> {
  @override
  Future<PaginatedResponse<ReportModel>> build() async {
    final repository = ref.watch(reportsRepositoryProvider);
    final filters = ref.watch(seekReportFiltersProvider);
    
    return repository.getAllReports(query: filters);
  }

  Future<void> goToPage(int page) async {
    final currentFilters = ref.read(seekReportFiltersProvider);
    ref.read(seekReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'page': page,
    };
  }

  Future<void> refresh() async {
    final currentFilters = ref.read(seekReportFiltersProvider);
    ref.read(seekReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'page': 1,
    };
  }
}
