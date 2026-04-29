// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) {
  return _ChatModel.fromJson(json);
}

/// @nodoc
mixin _$ChatModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  ChatUser get user => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<ChatMedia>? get media => throw _privateConstructorUsedError;
  ChatLocation? get location => throw _privateConstructorUsedError;
  int? get likesCount => throw _privateConstructorUsedError;
  int? get commentsCount => throw _privateConstructorUsedError;
  ChatModel? get replyTo => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChatModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatModelCopyWith<ChatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatModelCopyWith<$Res> {
  factory $ChatModelCopyWith(ChatModel value, $Res Function(ChatModel) then) =
      _$ChatModelCopyWithImpl<$Res, ChatModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    ChatUser user,
    String content,
    List<ChatMedia>? media,
    ChatLocation? location,
    int? likesCount,
    int? commentsCount,
    ChatModel? replyTo,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $ChatUserCopyWith<$Res> get user;
  $ChatLocationCopyWith<$Res>? get location;
  $ChatModelCopyWith<$Res>? get replyTo;
}

/// @nodoc
class _$ChatModelCopyWithImpl<$Res, $Val extends ChatModel>
    implements $ChatModelCopyWith<$Res> {
  _$ChatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? content = null,
    Object? media = freezed,
    Object? location = freezed,
    Object? likesCount = freezed,
    Object? commentsCount = freezed,
    Object? replyTo = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
                      as ChatUser,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            media: freezed == media
                ? _value.media
                : media // ignore: cast_nullable_to_non_nullable
                      as List<ChatMedia>?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as ChatLocation?,
            likesCount: freezed == likesCount
                ? _value.likesCount
                : likesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            commentsCount: freezed == commentsCount
                ? _value.commentsCount
                : commentsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            replyTo: freezed == replyTo
                ? _value.replyTo
                : replyTo // ignore: cast_nullable_to_non_nullable
                      as ChatModel?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatUserCopyWith<$Res> get user {
    return $ChatUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatLocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $ChatLocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatModelCopyWith<$Res>? get replyTo {
    if (_value.replyTo == null) {
      return null;
    }

    return $ChatModelCopyWith<$Res>(_value.replyTo!, (value) {
      return _then(_value.copyWith(replyTo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatModelImplCopyWith<$Res>
    implements $ChatModelCopyWith<$Res> {
  factory _$$ChatModelImplCopyWith(
    _$ChatModelImpl value,
    $Res Function(_$ChatModelImpl) then,
  ) = __$$ChatModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    ChatUser user,
    String content,
    List<ChatMedia>? media,
    ChatLocation? location,
    int? likesCount,
    int? commentsCount,
    ChatModel? replyTo,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $ChatUserCopyWith<$Res> get user;
  @override
  $ChatLocationCopyWith<$Res>? get location;
  @override
  $ChatModelCopyWith<$Res>? get replyTo;
}

/// @nodoc
class __$$ChatModelImplCopyWithImpl<$Res>
    extends _$ChatModelCopyWithImpl<$Res, _$ChatModelImpl>
    implements _$$ChatModelImplCopyWith<$Res> {
  __$$ChatModelImplCopyWithImpl(
    _$ChatModelImpl _value,
    $Res Function(_$ChatModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? content = null,
    Object? media = freezed,
    Object? location = freezed,
    Object? likesCount = freezed,
    Object? commentsCount = freezed,
    Object? replyTo = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ChatModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as ChatUser,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        media: freezed == media
            ? _value._media
            : media // ignore: cast_nullable_to_non_nullable
                  as List<ChatMedia>?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as ChatLocation?,
        likesCount: freezed == likesCount
            ? _value.likesCount
            : likesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        commentsCount: freezed == commentsCount
            ? _value.commentsCount
            : commentsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        replyTo: freezed == replyTo
            ? _value.replyTo
            : replyTo // ignore: cast_nullable_to_non_nullable
                  as ChatModel?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatModelImpl implements _ChatModel {
  const _$ChatModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.user,
    required this.content,
    final List<ChatMedia>? media,
    this.location,
    this.likesCount,
    this.commentsCount,
    this.replyTo,
    this.createdAt,
    this.updatedAt,
  }) : _media = media;

  factory _$ChatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final ChatUser user;
  @override
  final String content;
  final List<ChatMedia>? _media;
  @override
  List<ChatMedia>? get media {
    final value = _media;
    if (value == null) return null;
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final ChatLocation? location;
  @override
  final int? likesCount;
  @override
  final int? commentsCount;
  @override
  final ChatModel? replyTo;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChatModel(id: $id, user: $user, content: $content, media: $media, location: $location, likesCount: $likesCount, commentsCount: $commentsCount, replyTo: $replyTo, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.replyTo, replyTo) || other.replyTo == replyTo) &&
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
    content,
    const DeepCollectionEquality().hash(_media),
    location,
    likesCount,
    commentsCount,
    replyTo,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      __$$ChatModelImplCopyWithImpl<_$ChatModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatModelImplToJson(this);
  }
}

abstract class _ChatModel implements ChatModel {
  const factory _ChatModel({
    @JsonKey(name: '_id') required final String id,
    required final ChatUser user,
    required final String content,
    final List<ChatMedia>? media,
    final ChatLocation? location,
    final int? likesCount,
    final int? commentsCount,
    final ChatModel? replyTo,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ChatModelImpl;

  factory _ChatModel.fromJson(Map<String, dynamic> json) =
      _$ChatModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  ChatUser get user;
  @override
  String get content;
  @override
  List<ChatMedia>? get media;
  @override
  ChatLocation? get location;
  @override
  int? get likesCount;
  @override
  int? get commentsCount;
  @override
  ChatModel? get replyTo;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) {
  return _ChatUser.fromJson(json);
}

/// @nodoc
mixin _$ChatUser {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  ChatProfileImage? get profileImage => throw _privateConstructorUsedError;

  /// Serializes this ChatUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatUserCopyWith<ChatUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatUserCopyWith<$Res> {
  factory $ChatUserCopyWith(ChatUser value, $Res Function(ChatUser) then) =
      _$ChatUserCopyWithImpl<$Res, ChatUser>;
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    ChatProfileImage? profileImage,
  });

  $ChatProfileImageCopyWith<$Res>? get profileImage;
}

/// @nodoc
class _$ChatUserCopyWithImpl<$Res, $Val extends ChatUser>
    implements $ChatUserCopyWith<$Res> {
  _$ChatUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatUser
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
                      as ChatProfileImage?,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatProfileImageCopyWith<$Res>? get profileImage {
    if (_value.profileImage == null) {
      return null;
    }

    return $ChatProfileImageCopyWith<$Res>(_value.profileImage!, (value) {
      return _then(_value.copyWith(profileImage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatUserImplCopyWith<$Res>
    implements $ChatUserCopyWith<$Res> {
  factory _$$ChatUserImplCopyWith(
    _$ChatUserImpl value,
    $Res Function(_$ChatUserImpl) then,
  ) = __$$ChatUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    ChatProfileImage? profileImage,
  });

  @override
  $ChatProfileImageCopyWith<$Res>? get profileImage;
}

/// @nodoc
class __$$ChatUserImplCopyWithImpl<$Res>
    extends _$ChatUserCopyWithImpl<$Res, _$ChatUserImpl>
    implements _$$ChatUserImplCopyWith<$Res> {
  __$$ChatUserImplCopyWithImpl(
    _$ChatUserImpl _value,
    $Res Function(_$ChatUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatUser
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
      _$ChatUserImpl(
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
                  as ChatProfileImage?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatUserImpl implements _ChatUser {
  const _$ChatUserImpl({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  factory _$ChatUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatUserImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final ChatProfileImage? profileImage;

  @override
  String toString() {
    return 'ChatUser(id: $id, firstName: $firstName, lastName: $lastName, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatUserImpl &&
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

  /// Create a copy of ChatUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatUserImplCopyWith<_$ChatUserImpl> get copyWith =>
      __$$ChatUserImplCopyWithImpl<_$ChatUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatUserImplToJson(this);
  }
}

abstract class _ChatUser implements ChatUser {
  const factory _ChatUser({
    required final String id,
    required final String firstName,
    required final String lastName,
    final ChatProfileImage? profileImage,
  }) = _$ChatUserImpl;

  factory _ChatUser.fromJson(Map<String, dynamic> json) =
      _$ChatUserImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  ChatProfileImage? get profileImage;

  /// Create a copy of ChatUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatUserImplCopyWith<_$ChatUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatProfileImage _$ChatProfileImageFromJson(Map<String, dynamic> json) {
  return _ChatProfileImage.fromJson(json);
}

/// @nodoc
mixin _$ChatProfileImage {
  @JsonKey(name: 'public_id')
  String get publicId => throw _privateConstructorUsedError;
  @JsonKey(name: 'secure_url')
  String get secureUrl => throw _privateConstructorUsedError;

  /// Serializes this ChatProfileImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatProfileImageCopyWith<ChatProfileImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatProfileImageCopyWith<$Res> {
  factory $ChatProfileImageCopyWith(
    ChatProfileImage value,
    $Res Function(ChatProfileImage) then,
  ) = _$ChatProfileImageCopyWithImpl<$Res, ChatProfileImage>;
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    @JsonKey(name: 'secure_url') String secureUrl,
  });
}

/// @nodoc
class _$ChatProfileImageCopyWithImpl<$Res, $Val extends ChatProfileImage>
    implements $ChatProfileImageCopyWith<$Res> {
  _$ChatProfileImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatProfileImage
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
abstract class _$$ChatProfileImageImplCopyWith<$Res>
    implements $ChatProfileImageCopyWith<$Res> {
  factory _$$ChatProfileImageImplCopyWith(
    _$ChatProfileImageImpl value,
    $Res Function(_$ChatProfileImageImpl) then,
  ) = __$$ChatProfileImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    @JsonKey(name: 'secure_url') String secureUrl,
  });
}

/// @nodoc
class __$$ChatProfileImageImplCopyWithImpl<$Res>
    extends _$ChatProfileImageCopyWithImpl<$Res, _$ChatProfileImageImpl>
    implements _$$ChatProfileImageImplCopyWith<$Res> {
  __$$ChatProfileImageImplCopyWithImpl(
    _$ChatProfileImageImpl _value,
    $Res Function(_$ChatProfileImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? publicId = null, Object? secureUrl = null}) {
    return _then(
      _$ChatProfileImageImpl(
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
class _$ChatProfileImageImpl implements _ChatProfileImage {
  const _$ChatProfileImageImpl({
    @JsonKey(name: 'public_id') required this.publicId,
    @JsonKey(name: 'secure_url') required this.secureUrl,
  });

  factory _$ChatProfileImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatProfileImageImplFromJson(json);

  @override
  @JsonKey(name: 'public_id')
  final String publicId;
  @override
  @JsonKey(name: 'secure_url')
  final String secureUrl;

  @override
  String toString() {
    return 'ChatProfileImage(publicId: $publicId, secureUrl: $secureUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatProfileImageImpl &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.secureUrl, secureUrl) ||
                other.secureUrl == secureUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, publicId, secureUrl);

  /// Create a copy of ChatProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatProfileImageImplCopyWith<_$ChatProfileImageImpl> get copyWith =>
      __$$ChatProfileImageImplCopyWithImpl<_$ChatProfileImageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatProfileImageImplToJson(this);
  }
}

abstract class _ChatProfileImage implements ChatProfileImage {
  const factory _ChatProfileImage({
    @JsonKey(name: 'public_id') required final String publicId,
    @JsonKey(name: 'secure_url') required final String secureUrl,
  }) = _$ChatProfileImageImpl;

  factory _ChatProfileImage.fromJson(Map<String, dynamic> json) =
      _$ChatProfileImageImpl.fromJson;

  @override
  @JsonKey(name: 'public_id')
  String get publicId;
  @override
  @JsonKey(name: 'secure_url')
  String get secureUrl;

  /// Create a copy of ChatProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatProfileImageImplCopyWith<_$ChatProfileImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMedia _$ChatMediaFromJson(Map<String, dynamic> json) {
  return _ChatMedia.fromJson(json);
}

/// @nodoc
mixin _$ChatMedia {
  String get url => throw _privateConstructorUsedError;
  String get publicId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this ChatMedia to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMediaCopyWith<ChatMedia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMediaCopyWith<$Res> {
  factory $ChatMediaCopyWith(ChatMedia value, $Res Function(ChatMedia) then) =
      _$ChatMediaCopyWithImpl<$Res, ChatMedia>;
  @useResult
  $Res call({String url, String publicId, String type});
}

/// @nodoc
class _$ChatMediaCopyWithImpl<$Res, $Val extends ChatMedia>
    implements $ChatMediaCopyWith<$Res> {
  _$ChatMediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMedia
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
abstract class _$$ChatMediaImplCopyWith<$Res>
    implements $ChatMediaCopyWith<$Res> {
  factory _$$ChatMediaImplCopyWith(
    _$ChatMediaImpl value,
    $Res Function(_$ChatMediaImpl) then,
  ) = __$$ChatMediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String publicId, String type});
}

/// @nodoc
class __$$ChatMediaImplCopyWithImpl<$Res>
    extends _$ChatMediaCopyWithImpl<$Res, _$ChatMediaImpl>
    implements _$$ChatMediaImplCopyWith<$Res> {
  __$$ChatMediaImplCopyWithImpl(
    _$ChatMediaImpl _value,
    $Res Function(_$ChatMediaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? publicId = null,
    Object? type = null,
  }) {
    return _then(
      _$ChatMediaImpl(
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
class _$ChatMediaImpl implements _ChatMedia {
  const _$ChatMediaImpl({
    required this.url,
    required this.publicId,
    required this.type,
  });

  factory _$ChatMediaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMediaImplFromJson(json);

  @override
  final String url;
  @override
  final String publicId;
  @override
  final String type;

  @override
  String toString() {
    return 'ChatMedia(url: $url, publicId: $publicId, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMediaImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, publicId, type);

  /// Create a copy of ChatMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMediaImplCopyWith<_$ChatMediaImpl> get copyWith =>
      __$$ChatMediaImplCopyWithImpl<_$ChatMediaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMediaImplToJson(this);
  }
}

abstract class _ChatMedia implements ChatMedia {
  const factory _ChatMedia({
    required final String url,
    required final String publicId,
    required final String type,
  }) = _$ChatMediaImpl;

  factory _ChatMedia.fromJson(Map<String, dynamic> json) =
      _$ChatMediaImpl.fromJson;

  @override
  String get url;
  @override
  String get publicId;
  @override
  String get type;

  /// Create a copy of ChatMedia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMediaImplCopyWith<_$ChatMediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatLocation _$ChatLocationFromJson(Map<String, dynamic> json) {
  return _ChatLocation.fromJson(json);
}

/// @nodoc
mixin _$ChatLocation {
  String get type => throw _privateConstructorUsedError;
  List<double> get coordinates => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this ChatLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatLocationCopyWith<ChatLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatLocationCopyWith<$Res> {
  factory $ChatLocationCopyWith(
    ChatLocation value,
    $Res Function(ChatLocation) then,
  ) = _$ChatLocationCopyWithImpl<$Res, ChatLocation>;
  @useResult
  $Res call({String type, List<double> coordinates, String? address});
}

/// @nodoc
class _$ChatLocationCopyWithImpl<$Res, $Val extends ChatLocation>
    implements $ChatLocationCopyWith<$Res> {
  _$ChatLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatLocation
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
abstract class _$$ChatLocationImplCopyWith<$Res>
    implements $ChatLocationCopyWith<$Res> {
  factory _$$ChatLocationImplCopyWith(
    _$ChatLocationImpl value,
    $Res Function(_$ChatLocationImpl) then,
  ) = __$$ChatLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, List<double> coordinates, String? address});
}

/// @nodoc
class __$$ChatLocationImplCopyWithImpl<$Res>
    extends _$ChatLocationCopyWithImpl<$Res, _$ChatLocationImpl>
    implements _$$ChatLocationImplCopyWith<$Res> {
  __$$ChatLocationImplCopyWithImpl(
    _$ChatLocationImpl _value,
    $Res Function(_$ChatLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
    Object? address = freezed,
  }) {
    return _then(
      _$ChatLocationImpl(
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
class _$ChatLocationImpl implements _ChatLocation {
  const _$ChatLocationImpl({
    required this.type,
    required final List<double> coordinates,
    this.address,
  }) : _coordinates = coordinates;

  factory _$ChatLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatLocationImplFromJson(json);

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
    return 'ChatLocation(type: $type, coordinates: $coordinates, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatLocationImpl &&
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

  /// Create a copy of ChatLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatLocationImplCopyWith<_$ChatLocationImpl> get copyWith =>
      __$$ChatLocationImplCopyWithImpl<_$ChatLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatLocationImplToJson(this);
  }
}

abstract class _ChatLocation implements ChatLocation {
  const factory _ChatLocation({
    required final String type,
    required final List<double> coordinates,
    final String? address,
  }) = _$ChatLocationImpl;

  factory _ChatLocation.fromJson(Map<String, dynamic> json) =
      _$ChatLocationImpl.fromJson;

  @override
  String get type;
  @override
  List<double> get coordinates;
  @override
  String? get address;

  /// Create a copy of ChatLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatLocationImplCopyWith<_$ChatLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
