import 'package:flutter_riverpod/flutter_riverpod.dart';

final seekReportFiltersProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'page': 1,
    'limit': 10,
    'status': 'all',
    'sortBy': 'date',
    'sort': 'descending',
  };
});
