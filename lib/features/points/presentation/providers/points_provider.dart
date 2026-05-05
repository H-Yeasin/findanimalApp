import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../data/models/points_history_item_model.dart';
import '../../data/models/redeemable_item_model.dart';
import '../../data/repositories/points_repository_impl.dart';

class PointsState {
  const PointsState({
    required this.totalPoints,
    required this.history,
    required this.redeemableItems,
    this.currentCategory,
    this.currentType,
  });

  final int totalPoints;
  final List<PointsHistoryItemModel> history;
  final List<RedeemableItemModel> redeemableItems;
  final String? currentCategory;
  final String? currentType;

  PointsState copyWith({
    int? totalPoints,
    List<PointsHistoryItemModel>? history,
    List<RedeemableItemModel>? redeemableItems,
    String? currentCategory,
    String? currentType,
  }) {
    return PointsState(
      totalPoints: totalPoints ?? this.totalPoints,
      history: history ?? this.history,
      redeemableItems: redeemableItems ?? this.redeemableItems,
      currentCategory: currentCategory ?? this.currentCategory,
      currentType: currentType ?? this.currentType,
    );
  }
}

class PointsNotifier extends AsyncNotifier<PointsState> {
  @override
  Future<PointsState> build() async {
    final profile = await ref.watch(myProfileProvider.future);
    final pointsFromProfile = profile.pointsBalance ?? 0;
    final repository = ref.watch(pointsRepositoryProvider);

    final rewards = await repository.getAllRewards(
      category: state.valueOrNull?.currentCategory,
      type: state.valueOrNull?.currentType,
    );

    // For history, we'll keep the mock data for now as the API endpoint wasn't provided,
    // but we use the real points balance and rewards.
    return PointsState(
      totalPoints: pointsFromProfile,
      history: [
        PointsHistoryItemModel(
          id: '1',
          points: 10,
          reason: 'Reporting',
          createdAt: DateTime(2026, 12, 3),
        ),
        PointsHistoryItemModel(
          id: '2',
          points: 70,
          reason: 'Local mission',
          createdAt: DateTime(2026, 3, 2),
        ),
        PointsHistoryItemModel(
          id: '3',
          points: 10,
          reason: 'Reporting',
          createdAt: DateTime(2026, 3, 1),
        ),
      ],
      redeemableItems: rewards,
      currentCategory: state.valueOrNull?.currentCategory,
      currentType: state.valueOrNull?.currentType,
    );
  }

  Future<void> setCategory(String? category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.valueOrNull;
      final profile = await ref.read(myProfileProvider.future);
      final repository = ref.read(pointsRepositoryProvider);

      final rewards = await repository.getAllRewards(
        category: category,
        type: currentState?.currentType,
      );

      return PointsState(
        totalPoints: profile.pointsBalance ?? 0,
        history: currentState?.history ?? [],
        redeemableItems: rewards,
        currentCategory: category,
        currentType: currentState?.currentType,
      );
    });
  }

  Future<void> setType(String? type) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.valueOrNull;
      final profile = await ref.read(myProfileProvider.future);
      final repository = ref.read(pointsRepositoryProvider);

      final rewards = await repository.getAllRewards(
        category: currentState?.currentCategory,
        type: type,
      );

      return PointsState(
        totalPoints: profile.pointsBalance ?? 0,
        history: currentState?.history ?? [],
        redeemableItems: rewards,
        currentCategory: currentState?.currentCategory,
        currentType: type,
      );
    });
  }
}

final pointsProvider = AsyncNotifierProvider<PointsNotifier, PointsState>(
  PointsNotifier.new,
);
