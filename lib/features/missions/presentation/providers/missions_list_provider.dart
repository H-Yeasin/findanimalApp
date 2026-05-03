import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/paginated_response.dart';
import '../../data/models/mission_model.dart';
import '../../data/repositories/missions_repository_impl.dart';
import 'missions_filters_provider.dart';

part 'missions_list_provider.g.dart';

@riverpod
class MissionsList extends _$MissionsList {
  @override
  Future<PaginatedResponse<MissionModel>> build() async {
    final repository = ref.watch(missionsRepositoryProvider);
    final filters = ref.watch(missionsFiltersProvider);

    return repository.getAllMissions(query: filters);
  }

  Future<void> goToPage(int page) async {
    final currentFilters = ref.read(missionsFiltersProvider);
    ref.read(missionsFiltersProvider.notifier).state = {
      ...currentFilters,
      'page': page,
    };
  }

  Future<void> refresh() async {
    final currentFilters = ref.read(missionsFiltersProvider);
    ref.read(missionsFiltersProvider.notifier).state = {
      ...currentFilters,
      'page': 1,
    };
  }
}
