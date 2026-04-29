// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) {
  return _StoryModel.fromJson(json);
}

/// @nodoc
mixin _$StoryModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  StoryUser get user => throw _privateConstructorUsedError;
  StoryMedia get media => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  StoryLocation get location => throw _privateConstructorUsedError;
  int get viewsCount => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryModelCopyWith<StoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryModelCopyWith<$Res> {
  factory $StoryModelCopyWith(
    StoryModel value,
    $Res Function(StoryModel) then,
  ) = _$StoryModelCopyWithImpl<$Res, StoryModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    StoryUser user,
    StoryMedia media,
    String? caption,
    StoryLocation location,
    int viewsCount,
    DateTime expiresAt,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $StoryUserCopyWith<$Res> get user;
  $StoryMediaCopyWith<$Res> get media;
  $StoryLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$StoryModelCopyWithImpl<$Res, $Val extends StoryModel>
    implements $StoryModelCopyWith<$Res> {
  _$StoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? media = null,
    Object? caption = freezed,
    Object? location = null,
    Object? viewsCount = null,
    Object? expiresAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as StoryUser,
            media: null == media
                ? _value.media
                : media // ignore: cast_nullable_to_non_nullable
                      as StoryMedia,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as StoryLocation,
            viewsCount: null == viewsCount
                ? _value.viewsCount
                : viewsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoryUserCopyWith<$Res> get user {
    return $StoryUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoryMediaCopyWith<$Res> get media {
    return $StoryMediaCopyWith<$Res>(_value.media, (value) {
      return _then(_value.copyWith(media: value) as $Val);
    });
  }

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoryLocationCopyWith<$Res> get location {
    return $StoryLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoryModelImplCopyWith<$Res>
    implements $StoryModelCopyWith<$Res> {
  factory _$$StoryModelImplCopyWith(
    _$StoryModelImpl value,
    $Res Function(_$StoryModelImpl) then,
  ) = __$$StoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    StoryUser user,
    StoryMedia media,
    String? caption,
    StoryLocation location,
    int viewsCount,
    DateTime expiresAt,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $StoryUserCopyWith<$Res> get user;
  @override
  $StoryMediaCopyWith<$Res> get media;
  @override
  $StoryLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$StoryModelImplCopyWithImpl<$Res>
    extends _$StoryModelCopyWithImpl<$Res, _$StoryModelImpl>
    implements _$$StoryModelImplCopyWith<$Res> {
  __$$StoryModelImplCopyWithImpl(
    _$StoryModelImpl _value,
    $Res Function(_$StoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? media = null,
    Object? caption = freezed,
    Object? location = null,
    Object? viewsCount = null,
    Object? expiresAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$StoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as StoryUser,
        media: null == media
            ? _value.media
            : media // ignore: cast_nullable_to_non_nullable
                  as StoryMedia,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as StoryLocation,
        viewsCount: null == viewsCount
            ? _value.viewsCount
            : viewsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryModelImpl implements _StoryModel {
  const _$StoryModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.user,
    required this.media,
    this.caption,
    required this.location,
    required this.viewsCount,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$StoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final StoryUser user;
  @override
  final StoryMedia media;
  @override
  final String? caption;
  @override
  final StoryLocation location;
  @override
  final int viewsCount;
  @override
  final DateTime expiresAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'StoryModel(id: $id, user: $user, media: $media, caption: $caption, location: $location, viewsCount: $viewsCount, expiresAt: $expiresAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.media, media) || other.media == media) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    user,
    media,
    caption,
    location,
    viewsCount,
    expiresAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryModelImplCopyWith<_$StoryModelImpl> get copyWith =>
      __$$StoryModelImplCopyWithImpl<_$StoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryModelImplToJson(this);
  }
}

abstract class _StoryModel implements StoryModel {
  const factory _StoryModel({
    @JsonKey(name: '_id') required final String id,
    required final StoryUser user,
    required final StoryMedia media,
    final String? caption,
    required final StoryLocation location,
    required final int viewsCount,
    required final DateTime expiresAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$StoryModelImpl;

  factory _StoryModel.fromJson(Map<String, dynamic> json) =
      _$StoryModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  StoryUser get user;
  @override
  StoryMedia get media;
  @override
  String? get caption;
  @override
  StoryLocation get location;
  @override
  int get viewsCount;
  @override
  DateTime get expiresAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryModelImplCopyWith<_$StoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryUser _$StoryUserFromJson(Map<String, dynamic> json) {
  return _StoryUser.fromJson(json);
}

/// @nodoc
mixin _$StoryUser {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  StoryProfileImage? get profileImage => throw _privateConstructorUsedError;

  /// Serializes this StoryUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryUserCopyWith<StoryUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryUserCopyWith<$Res> {
  factory $StoryUserCopyWith(StoryUser value, $Res Function(StoryUser) then) =
      _$StoryUserCopyWithImpl<$Res, StoryUser>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String firstName,
    String lastName,
    StoryProfileImage? profileImage,
  });

  $StoryProfileImageCopyWith<$Res>? get profileImage;
}

/// @nodoc
class _$StoryUserCopyWithImpl<$Res, $Val extends StoryUser>
    implements $StoryUserCopyWith<$Res> {
  _$StoryUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? profileImage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImage: freezed == profileImage
                ? _value.profileImage
                : profileImage // ignore: cast_nullable_to_non_nullable
                      as StoryProfileImage?,
          )
          as $Val,
    );
  }

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoryProfileImageCopyWith<$Res>? get profileImage {
    if (_value.profileImage == null) {
      return null;
    }

    return $StoryProfileImageCopyWith<$Res>(_value.profileImage!, (value) {
      return _then(_value.copyWith(profileImage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoryUserImplCopyWith<$Res>
    implements $StoryUserCopyWith<$Res> {
  factory _$$StoryUserImplCopyWith(
    _$StoryUserImpl value,
    $Res Function(_$StoryUserImpl) then,
  ) = __$$StoryUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String firstName,
    String lastName,
    StoryProfileImage? profileImage,
  });

  @override
  $StoryProfileImageCopyWith<$Res>? get profileImage;
}

/// @nodoc
class __$$StoryUserImplCopyWithImpl<$Res>
    extends _$StoryUserCopyWithImpl<$Res, _$StoryUserImpl>
    implements _$$StoryUserImplCopyWith<$Res> {
  __$$StoryUserImplCopyWithImpl(
    _$StoryUserImpl _value,
    $Res Function(_$StoryUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? profileImage = freezed,
  }) {
    return _then(
      _$StoryUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImage: freezed == profileImage
            ? _value.profileImage
            : profileImage // ignore: cast_nullable_to_non_nullable
                  as StoryProfileImage?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryUserImpl implements _StoryUser {
  const _$StoryUserImpl({
    @JsonKey(name: '_id') required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  factory _$StoryUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryUserImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final StoryProfileImage? profileImage;

  @override
  String toString() {
    return 'StoryUser(id: $id, firstName: $firstName, lastName: $lastName, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, firstName, lastName, profileImage);

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryUserImplCopyWith<_$StoryUserImpl> get copyWith =>
      __$$StoryUserImplCopyWithImpl<_$StoryUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryUserImplToJson(this);
  }
}

abstract class _StoryUser implements StoryUser {
  const factory _StoryUser({
    @JsonKey(name: '_id') required final String id,
    required final String firstName,
    required final String lastName,
    final StoryProfileImage? profileImage,
  }) = _$StoryUserImpl;

  factory _StoryUser.fromJson(Map<String, dynamic> json) =
      _$StoryUserImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  StoryProfileImage? get profileImage;

  /// Create a copy of StoryUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryUserImplCopyWith<_$StoryUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryProfileImage _$StoryProfileImageFromJson(Map<String, dynamic> json) {
  return _StoryProfileImage.fromJson(json);
}

/// @nodoc
mixin _$StoryProfileImage {
  @JsonKey(name: 'public_id')
  String get publicId => throw _privateConstructorUsedError;
  @JsonKey(name: 'secure_url')
  String get secureUrl => throw _privateConstructorUsedError;

  /// Serializes this StoryProfileImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryProfileImageCopyWith<StoryProfileImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryProfileImageCopyWith<$Res> {
  factory $StoryProfileImageCopyWith(
    StoryProfileImage value,
    $Res Function(StoryProfileImage) then,
  ) = _$StoryProfileImageCopyWithImpl<$Res, StoryProfileImage>;
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    @JsonKey(name: 'secure_url') String secureUrl,
  });
}

/// @nodoc
class _$StoryProfileImageCopyWithImpl<$Res, $Val extends StoryProfileImage>
    implements $StoryProfileImageCopyWith<$Res> {
  _$StoryProfileImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? publicId = null, Object? secureUrl = null}) {
    return _then(
      _value.copyWith(
            publicId: null == publicId
                ? _value.publicId
                : publicId // ignore: cast_nullable_to_non_nullable
                      as String,
            secureUrl: null == secureUrl
                ? _value.secureUrl
                : secureUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoryProfileImageImplCopyWith<$Res>
    implements $StoryProfileImageCopyWith<$Res> {
  factory _$$StoryProfileImageImplCopyWith(
    _$StoryProfileImageImpl value,
    $Res Function(_$StoryProfileImageImpl) then,
  ) = __$$StoryProfileImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    @JsonKey(name: 'secure_url') String secureUrl,
  });
}

/// @nodoc
class __$$StoryProfileImageImplCopyWithImpl<$Res>
    extends _$StoryProfileImageCopyWithImpl<$Res, _$StoryProfileImageImpl>
    implements _$$StoryProfileImageImplCopyWith<$Res> {
  __$$StoryProfileImageImplCopyWithImpl(
    _$StoryProfileImageImpl _value,
    $Res Function(_$StoryProfileImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoryProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? publicId = null, Object? secureUrl = null}) {
    return _then(
      _$StoryProfileImageImpl(
        publicId: null == publicId
            ? _value.publicId
            : publicId // ignore: cast_nullable_to_non_nullable
                  as String,
        secureUrl: null == secureUrl
            ? _value.secureUrl
            : secureUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryProfileImageImpl implements _StoryProfileImage {
  const _$StoryProfileImageImpl({
    @JsonKey(name: 'public_id') required this.publicId,
    @JsonKey(name: 'secure_url') required this.secureUrl,
  });

  factory _$StoryProfileImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryProfileImageImplFromJson(json);

  @override
  @JsonKey(name: 'public_id')
  final String publicId;
  @override
  @JsonKey(name: 'secure_url')
  final String secureUrl;

  @override
  String toString() {
    return 'StoryProfileImage(publicId: $publicId, secureUrl: $secureUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryProfileImageImpl &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.secureUrl, secureUrl) ||
                other.secureUrl == secureUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, publicId, secureUrl);

  /// Create a copy of StoryProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryProfileImageImplCopyWith<_$StoryProfileImageImpl> get copyWith =>
      __$$StoryProfileImageImplCopyWithImpl<_$StoryProfileImageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryProfileImageImplToJson(this);
  }
}

abstract class _StoryProfileImage implements StoryProfileImage {
  const factory _StoryProfileImage({
    @JsonKey(name: 'public_id') required final String publicId,
    @JsonKey(name: 'secure_url') required final String secureUrl,
  }) = _$StoryProfileImageImpl;

  factory _StoryProfileImage.fromJson(Map<String, dynamic> json) =
      _$StoryProfileImageImpl.fromJson;

  @override
  @JsonKey(name: 'public_id')
  String get publicId;
  @override
  @JsonKey(name: 'secure_url')
  String get secureUrl;

  /// Create a copy of StoryProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryProfileImageImplCopyWith<_$StoryProfileImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryMedia _$StoryMediaFromJson(Map<String, dynamic> json) {
  return _StoryMedia.fromJson(json);
}

/// @nodoc
mixin _$StoryMedia {
  String get url => throw _privateConstructorUsedError;
  String get publicId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this StoryMedia to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryMediaCopyWith<StoryMedia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryMediaCopyWith<$Res> {
  factory $StoryMediaCopyWith(
    StoryMedia value,
    $Res Function(StoryMedia) then,
  ) = _$StoryMediaCopyWithImpl<$Res, StoryMedia>;
  @useResult
  $Res call({String url, String publicId, String type});
}

/// @nodoc
class _$StoryMediaCopyWithImpl<$Res, $Val extends StoryMedia>
    implements $StoryMediaCopyWith<$Res> {
  _$StoryMediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? publicId = null,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            publicId: null == publicId
                ? _value.publicId
                : publicId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoryMediaImplCopyWith<$Res>
    implements $StoryMediaCopyWith<$Res> {
  factory _$$StoryMediaImplCopyWith(
    _$StoryMediaImpl value,
    $Res Function(_$StoryMediaImpl) then,
  ) = __$$StoryMediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String publicId, String type});
}

/// @nodoc
class __$$StoryMediaImplCopyWithImpl<$Res>
    extends _$StoryMediaCopyWithImpl<$Res, _$StoryMediaImpl>
    implements _$$StoryMediaImplCopyWith<$Res> {
  __$$StoryMediaImplCopyWithImpl(
    _$StoryMediaImpl _value,
    $Res Function(_$StoryMediaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoryMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? publicId = null,
    Object? type = null,
  }) {
    return _then(
      _$StoryMediaImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        publicId: null == publicId
            ? _value.publicId
            : publicId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryMediaImpl implements _StoryMedia {
  const _$StoryMediaImpl({
    required this.url,
    required this.publicId,
    required this.type,
  });

  factory _$StoryMediaImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryMediaImplFromJson(json);

  @override
  final String url;
  @override
  final String publicId;
  @override
  final String type;

  @override
  String toString() {
    return 'StoryMedia(url: $url, publicId: $publicId, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryMediaImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, publicId, type);

  /// Create a copy of StoryMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryMediaImplCopyWith<_$StoryMediaImpl> get copyWith =>
      __$$StoryMediaImplCopyWithImpl<_$StoryMediaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryMediaImplToJson(this);
  }
}

abstract class _StoryMedia implements StoryMedia {
  const factory _StoryMedia({
    required final String url,
    required final String publicId,
    required final String type,
  }) = _$StoryMediaImpl;

  factory _StoryMedia.fromJson(Map<String, dynamic> json) =
      _$StoryMediaImpl.fromJson;

  @override
  String get url;
  @override
  String get publicId;
  @override
  String get type;

  /// Create a copy of StoryMedia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryMediaImplCopyWith<_$StoryMediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryLocation _$StoryLocationFromJson(Map<String, dynamic> json) {
  return _StoryLocation.fromJson(json);
}

/// @nodoc
mixin _$StoryLocation {
  String get type => throw _privateConstructorUsedError;
  List<double> get coordinates => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this StoryLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryLocationCopyWith<StoryLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryLocationCopyWith<$Res> {
  factory $StoryLocationCopyWith(
    StoryLocation value,
    $Res Function(StoryLocation) then,
  ) = _$StoryLocationCopyWithImpl<$Res, StoryLocation>;
  @useResult
  $Res call({String type, List<double> coordinates, String? address});
}

/// @nodoc
class _$StoryLocationCopyWithImpl<$Res, $Val extends StoryLocation>
    implements $StoryLocationCopyWith<$Res> {
  _$StoryLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
    Object? address = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            coordinates: null == coordinates
                ? _value.coordinates
                : coordinates // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoryLocationImplCopyWith<$Res>
    implements $StoryLocationCopyWith<$Res> {
  factory _$$StoryLocationImplCopyWith(
    _$StoryLocationImpl value,
    $Res Function(_$StoryLocationImpl) then,
  ) = __$$StoryLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, List<double> coordinates, String? address});
}

/// @nodoc
class __$$StoryLocationImplCopyWithImpl<$Res>
    extends _$StoryLocationCopyWithImpl<$Res, _$StoryLocationImpl>
    implements _$$StoryLocationImplCopyWith<$Res> {
  __$$StoryLocationImplCopyWithImpl(
    _$StoryLocationImpl _value,
    $Res Function(_$StoryLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoryLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
    Object? address = freezed,
  }) {
    return _then(
      _$StoryLocationImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        coordinates: null == coordinates
            ? _value._coordinates
            : coordinates // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryLocationImpl implements _StoryLocation {
  const _$StoryLocationImpl({
    required this.type,
    required final List<double> coordinates,
    this.address,
  }) : _coordinates = coordinates;

  factory _$StoryLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryLocationImplFromJson(json);

  @override
  final String type;
  final List<double> _coordinates;
  @override
  List<double> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  final String? address;

  @override
  String toString() {
    return 'StoryLocation(type: $type, coordinates: $coordinates, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryLocationImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._coordinates,
              _coordinates,
            ) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_coordinates),
    address,
  );

  /// Create a copy of StoryLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryLocationImplCopyWith<_$StoryLocationImpl> get copyWith =>
      __$$StoryLocationImplCopyWithImpl<_$StoryLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryLocationImplToJson(this);
  }
}

abstract class _StoryLocation implements StoryLocation {
  const factory _StoryLocation({
    required final String type,
    required final List<double> coordinates,
    final String? address,
  }) = _$StoryLocationImpl;

  factory _StoryLocation.fromJson(Map<String, dynamic> json) =
      _$StoryLocationImpl.fromJson;

  @override
  String get type;
  @override
  List<double> get coordinates;
  @override
  String? get address;

  /// Create a copy of StoryLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryLocationImplCopyWith<_$StoryLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
