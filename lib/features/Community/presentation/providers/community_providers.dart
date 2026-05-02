import 'dart:io';
import 'package:hesteka_frontend/core/providers/location_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/story_model.dart';
import '../../data/repositories/community_repository_impl.dart';

part 'community_providers.g.dart';

@riverpod
Future<List<StoryModel>> localStories(LocalStoriesRef ref) async {
  // Refresh when auth state changes
  final authStatus = ref.watch(authStateProvider);
  if (authStatus != AuthStatus.authenticated) {
    return const <StoryModel>[];
  }

  final repository = ref.watch(communityRepositoryProvider);
  final userLocation = ref.watch(userLocationProvider).value;

  // Using user location if available, otherwise fallback to Paris
  final lat = userLocation?.latitude ?? 48.8566;
  final lng = userLocation?.longitude ?? 2.3522;

  final response = await repository.getLocalStories(
    query: {'lat': lat, 'lng': lng, 'radiusKm': 50, 'limit': 10},
  );
  return response.data;
}

@riverpod
Future<List<ChatModel>> localChat(LocalChatRef ref) async {
  // Refresh when auth state changes
  final authStatus = ref.watch(authStateProvider);
  if (authStatus != AuthStatus.authenticated) {
    return const <ChatModel>[];
  }

  final repository = ref.watch(communityRepositoryProvider);
  final userLocation = ref.watch(userLocationProvider).value;

  // Using user location if available, otherwise fallback to Paris
  final lat = userLocation?.latitude ?? 48.8566;
  final lng = userLocation?.longitude ?? 2.3522;

  final response = await repository.getLocalChat(
    query: {'lat': lat, 'lng': lng, 'radiusKm': 50, 'limit': 100},
  );
  return response.data;
}

@riverpod
class CommunityAction extends _$CommunityAction {
  @override
  FutureOr<void> build() async {}

  Future<void> createStory({
    required String caption,
    required File media,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (ref.read(authStateProvider) != AuthStatus.authenticated) {
        throw StateError('Please log in to share a story.');
      }

      final repository = ref.read(communityRepositoryProvider);
      await repository.createStory(
        caption: caption,
        media: media,
        lat: 48.8566,
        lng: 2.3522,
      );
      // Force an immediate refresh and wait for it
      // ignore: unused_result
      await ref.refresh(localStoriesProvider.future);
    });
  }

  Future<void> createChat({
    required String content,
    List<File>? media,
    String? replyTo,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (ref.read(authStateProvider) != AuthStatus.authenticated) {
        throw StateError('Please log in to post in community chat.');
      }

      final repository = ref.read(communityRepositoryProvider);
      await repository.createChat(
        content: content,
        media: media,
        lat: 48.8566,
        lng: 2.3522,
        replyTo: replyTo,
      );

      // Wait a bit for backend to index the new post
      await Future.delayed(const Duration(milliseconds: 100));

      // Force an immediate refresh and wait for it
      // ignore: unused_result
      await ref.refresh(localChatProvider.future);
    });
  }

  Future<void> toggleLike(String chatId) async {
    if (ref.read(authStateProvider) != AuthStatus.authenticated) {
      throw StateError('Please log in to react to posts.');
    }

    final repository = ref.read(communityRepositoryProvider);
    await repository.toggleChatLike(chatId);
    ref.invalidate(localChatProvider);
  }
}
