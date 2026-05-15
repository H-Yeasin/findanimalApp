// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myProfileHash() => r'79670eec23b6821a61edfee94f9fa6a20ed56313';

/// See also [myProfile].
@ProviderFor(myProfile)
final myProfileProvider = AutoDisposeFutureProvider<ProfileModel>.internal(
  myProfile,
  name: r'myProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyProfileRef = AutoDisposeFutureProviderRef<ProfileModel>;
String _$contactSupportHash() => r'08f922817360f9abc5d69f6323a3e6052b491dbf';

/// See also [ContactSupport].
@ProviderFor(ContactSupport)
final contactSupportProvider =
    AutoDisposeNotifierProvider<ContactSupport, AsyncValue<void>>.internal(
      ContactSupport.new,
      name: r'contactSupportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$contactSupportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ContactSupport = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
