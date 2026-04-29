import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/mission_model.dart';
import '../../data/repositories/missions_repository_impl.dart';

final partnerMissionsProvider = FutureProvider.autoDispose<List<MissionModel>>((
  ref,
) async {
  final repository = ref.watch(missionsRepositoryProvider);
  return repository.getMyMissions();
});
