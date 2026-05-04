import 'package:flutter_riverpod/flutter_riverpod.dart';

final seekReportFiltersProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'page': 1,
    'limit': 5,
    'status': <String>[],
    'sortBy': 'date',
    'sort': 'descending',
  };
});
