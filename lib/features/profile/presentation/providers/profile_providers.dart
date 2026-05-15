import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository_impl.dart';

part 'profile_providers.g.dart';

@riverpod
Future<ProfileModel> myProfile(MyProfileRef ref) async {
  // Watch auth session to refresh when user logs in/out
  ref.watch(authSessionProvider);

  final repository = ref.watch(profileRepositoryProvider);
  return repository.getMyProfile();
}

@riverpod
class ContactSupport extends _$ContactSupport {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> submitMessage({
    required String email,
    required String name,
    required String subject,
    required String message,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).submitSupportMessage({
        'email': email,
        'name': name,
        'subject': subject,
        'message': message,
      });
    });
  }
}
