import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository_impl.dart';

class UpdateProfileNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<ProfileModel> submit(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final profile = await ref.read(profileRepositoryProvider).updateProfile(data);
      state = const AsyncData(null);
      return profile;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final updateProfileProvider =
    AsyncNotifierProvider<UpdateProfileNotifier, void>(
      UpdateProfileNotifier.new,
    );
