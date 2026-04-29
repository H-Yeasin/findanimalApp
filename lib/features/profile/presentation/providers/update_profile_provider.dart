import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/profile_repository_impl.dart';

class UpdateProfileNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).updateProfile(data);
    });
  }
}

final updateProfileProvider =
    AsyncNotifierProvider<UpdateProfileNotifier, void>(
      UpdateProfileNotifier.new,
    );
