import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository_impl.dart';

part 'profile_providers.g.dart';

final profileImageCacheBusterProvider = StateProvider<int>((ref) => 0);

String? profileImageUrlWithCacheBuster(String? url, int cacheBuster) {
  if (url == null || url.trim().isEmpty || cacheBuster == 0) {
    return url;
  }

  final uri = Uri.tryParse(url);
  if (uri == null) {
    return url;
  }

  return uri
      .replace(
        queryParameters: {
          ...uri.queryParameters,
          'profileImageVersion': cacheBuster.toString(),
        },
      )
      .toString();
}

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
