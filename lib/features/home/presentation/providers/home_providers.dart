import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../seek/data/models/report_model.dart';
import '../../../seek/data/repositories/reports_repository_impl.dart';

final homeReportFiltersProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'page': 1,
    'limit': 10,
    'status': 'all',
    'sortBy': 'date',
    'sort': 'descending',
    'radius': 50,
  };
});

final homeReportsProvider = FutureProvider<List<ReportModel>>((ref) async {
  final repository = ref.watch(reportsRepositoryProvider);
  final filters = ref.watch(homeReportFiltersProvider);

  try {
    final response = await repository.getAllReports(query: filters);
    return response.data;
  } catch (e, stack) {
    if (kDebugMode) {
      print('Error fetching reports: $e');
    }
    if (kDebugMode) {
      print(stack);
    }
    rethrow;
  }
});

final homeStatsProvider = FutureProvider<Map<String, String>>((ref) async {
  final repository = ref.watch(reportsRepositoryProvider);

  // We make parallel calls to get counts for different statuses
  // The backend returns the total count in the 'meta' field
  final results = await Future.wait([
    repository.getAllReports(query: {'limit': 1}), // Total reports
    repository.getAllReports(
      query: {'status': 'found', 'limit': 1},
    ), // Animals Found
    repository.getAllReports(
      query: {'status': 'rescued', 'limit': 1},
    ), // Animals Rescued
  ]);

  return {
    'ANIMALS FOUND': results[1].total.toString(),
    'REPORTS': results[0].total.toString(),
    'ANIMALS RESCUED': results[2].total.toString(),
  };
});
