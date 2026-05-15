// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localStoriesHash() => r'5a8007d550c8b5a34548bcb7fabe39083eb91be4';

/// See also [localStories].
@ProviderFor(localStories)
final localStoriesProvider =
    AutoDisposeFutureProvider<List<StoryModel>>.internal(
      localStories,
      name: r'localStoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$localStoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalStoriesRef = AutoDisposeFutureProviderRef<List<StoryModel>>;
String _$localChatHash() => r'361046a6be2a700d5e4772dd966e22d7748f7c98';

/// See also [localChat].
@ProviderFor(localChat)
final localChatProvider = AutoDisposeFutureProvider<List<ChatModel>>.internal(
  localChat,
  name: r'localChatProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localChatHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalChatRef = AutoDisposeFutureProviderRef<List<ChatModel>>;
String _$communityActionHash() => r'b92df9e72c182a3ee0aab37452b2ee3ffa40355f';

/// See also [CommunityAction].
@ProviderFor(CommunityAction)
final communityActionProvider =
    AutoDisposeAsyncNotifierProvider<CommunityAction, void>.internal(
      CommunityAction.new,
      name: r'communityActionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$communityActionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CommunityAction = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
