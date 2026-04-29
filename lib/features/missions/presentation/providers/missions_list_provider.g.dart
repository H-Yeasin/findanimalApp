// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missions_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$missionsListHash() => r'9fa342d19798d48342b32af97f77ddc8713cb8ff';

/// See also [MissionsList].
@ProviderFor(MissionsList)
final missionsListProvider =
    AutoDisposeAsyncNotifierProvider<
      MissionsList,
      PaginatedResponse<MissionModel>
    >.internal(
      MissionsList.new,
      name: r'missionsListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$missionsListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MissionsList =
    AutoDisposeAsyncNotifier<PaginatedResponse<MissionModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
