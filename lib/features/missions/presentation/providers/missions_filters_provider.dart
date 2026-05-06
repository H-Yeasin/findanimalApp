import 'package:flutter_riverpod/flutter_riverpod.dart';

final missionsFiltersProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'page': 1,
    'limit': 10,
  };
});
