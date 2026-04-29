import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/paginated_response.dart';
import '../../data/models/mission_model.dart';
import '../../data/repositories/missions_repository_impl.dart';

part 'missions_list_provider.g.dart';

@riverpod
class MissionsList extends _$MissionsList {
  int _currentPage = 1;

  @override
  Future<PaginatedResponse<MissionModel>> build() async {
    final repository = ref.watch(missionsRepositoryProvider);
    return repository.getAllMissions(query: {'page': _currentPage, 'limit': 10});
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> refresh() async {
    _currentPage = 1;
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
