// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return _CommentModel.fromJson(json);
}

/// @nodoc
mixin _$CommentModel {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  CommentAuthor get author => throw _privateConstructorUsedError;
  String get report => throw _privateConstructorUsedError;
  CommentImage? get image => throw _privateConstructorUsedError;
  String? get parent => throw _privateConstructorUsedError;
  List<String> get likes => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<CommentModel> get replies => throw _privateConstructorUsedError;

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentModelCopyWith<CommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentModelCopyWith<$Res> {
  factory $CommentModelCopyWith(
    CommentModel value,
    $Res Function(CommentModel) then,
  ) = _$CommentModelCopyWithImpl<$Res, CommentModel>;
  @useResult
  $Res call({
    String id,
    String content,
    CommentAuthor author,
    String report,
    CommentImage? image,
    String? parent,
    List<String> likes,
    bool isDeleted,
    DateTime createdAt,
    DateTime updatedAt,
    List<CommentModel> replies,
  });

  $CommentAuthorCopyWith<$Res> get author;
  $CommentImageCopyWith<$Res>? get image;
}

/// @nodoc
class _$CommentModelCopyWithImpl<$Res, $Val extends CommentModel>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? author = null,
    Object? report = null,
    Object? image = freezed,
    Object? parent = freezed,
    Object? likes = null,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? replies = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as CommentAuthor,
            report: null == report
                ? _value.report
                : report // ignore: cast_nullable_to_non_nullable
                      as String,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as CommentImage?,
            parent: freezed == parent
                ? _value.parent
                : parent // ignore: cast_nullable_to_non_nullable
                      as String?,
            likes: null == likes
                ? _value.likes
                : likes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isDeleted: null == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            replies: null == replies
                ? _value.replies
                : replies // ignore: cast_nullable_to_non_nullable
                      as List<CommentModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentAuthorCopyWith<$Res> get author {
    return $CommentAuthorCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentImageCopyWith<$Res>? get image {
    if (_value.image == null) {
      return null;
    }

    return $CommentImageCopyWith<$Res>(_value.image!, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentModelImplCopyWith<$Res>
    implements $CommentModelCopyWith<$Res> {
  factory _$$CommentModelImplCopyWith(
    _$CommentModelImpl value,
    $Res Function(_$CommentModelImpl) then,
  ) = __$$CommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String content,
    CommentAuthor author,
    String report,
    CommentImage? image,
    String? parent,
    List<String> likes,
    bool isDeleted,
    DateTime createdAt,
    DateTime updatedAt,
    List<CommentModel> replies,
  });

  @override
  $CommentAuthorCopyWith<$Res> get author;
  @override
  $CommentImageCopyWith<$Res>? get image;
}

/// @nodoc
class __$$CommentModelImplCopyWithImpl<$Res>
    extends _$CommentModelCopyWithImpl<$Res, _$CommentModelImpl>
    implements _$$CommentModelImplCopyWith<$Res> {
  __$$CommentModelImplCopyWithImpl(
    _$CommentModelImpl _value,
    $Res Function(_$CommentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? author = null,
    Object? report = null,
    Object? image = freezed,
    Object? parent = freezed,
    Object? likes = null,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? replies = null,
  }) {
    return _then(
      _$CommentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as CommentAuthor,
        report: null == report
            ? _value.report
            : report // ignore: cast_nullable_to_non_nullable
                  as String,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as CommentImage?,
        parent: freezed == parent
            ? _value.parent
            : parent // ignore: cast_nullable_to_non_nullable
                  as String?,
        likes: null == likes
            ? _value._likes
            : likes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isDeleted: null == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        replies: null == replies
            ? _value._replies
            : replies // ignore: cast_nullable_to_non_nullable
                  as List<CommentModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentModelImpl with DiagnosticableTreeMixin implements _CommentModel {
  const _$CommentModelImpl({
    required this.id,
    required this.content,
    required this.author,
    required this.report,
    this.image,
    this.parent,
    required final List<String> likes,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    final List<CommentModel> replies = const [],
  }) : _likes = likes,
       _replies = replies;

  factory _$CommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final CommentAuthor author;
  @override
  final String report;
  @override
  final CommentImage? image;
  @override
  final String? parent;
  final List<String> _likes;
  @override
  List<String> get likes {
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likes);
  }

  @override
  final bool isDeleted;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<CommentModel> _replies;
  @override
  @JsonKey()
  List<CommentModel> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CommentModel(id: $id, content: $content, author: $author, report: $report, image: $image, parent: $parent, likes: $likes, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, replies: $replies)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CommentModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('content', content))
      ..add(DiagnosticsProperty('author', author))
      ..add(DiagnosticsProperty('report', report))
      ..add(DiagnosticsProperty('image', image))
      ..add(DiagnosticsProperty('parent', parent))
      ..add(DiagnosticsProperty('likes', likes))
      ..add(DiagnosticsProperty('isDeleted', isDeleted))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('replies', replies));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.report, report) || other.report == report) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    content,
    author,
    report,
    image,
    parent,
    const DeepCollectionEquality().hash(_likes),
    isDeleted,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_replies),
  );

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      __$$CommentModelImplCopyWithImpl<_$CommentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentModelImplToJson(this);
  }
}

abstract class _CommentModel implements CommentModel {
  const factory _CommentModel({
    required final String id,
    required final String content,
    required final CommentAuthor author,
    required final String report,
    final CommentImage? image,
    final String? parent,
    required final List<String> likes,
    required final bool isDeleted,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final List<CommentModel> replies,
  }) = _$CommentModelImpl;

  factory _CommentModel.fromJson(Map<String, dynamic> json) =
      _$CommentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  CommentAuthor get author;
  @override
  String get report;
  @override
  CommentImage? get image;
  @override
  String? get parent;
  @override
  List<String> get likes;
  @override
  bool get isDeleted;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<CommentModel> get replies;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentAuthor _$CommentAuthorFromJson(Map<String, dynamic> json) {
  return _CommentAuthor.fromJson(json);
}

/// @nodoc
mixin _$CommentAuthor {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  @ProfileImageConverter()
  String? get profileImage => throw _privateConstructorUsedError;

  /// Serializes this CommentAuthor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentAuthorCopyWith<CommentAuthor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentAuthorCopyWith<$Res> {
  factory $CommentAuthorCopyWith(
    CommentAuthor value,
    $Res Function(CommentAuthor) then,
  ) = _$CommentAuthorCopyWithImpl<$Res, CommentAuthor>;
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    @ProfileImageConverter() String? profileImage,
  });
}

/// @nodoc
class _$CommentAuthorCopyWithImpl<$Res, $Val extends CommentAuthor>
    implements $CommentAuthorCopyWith<$Res> {
  _$CommentAuthorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentAuthor
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
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommentAuthorImplCopyWith<$Res>
    implements $CommentAuthorCopyWith<$Res> {
  factory _$$CommentAuthorImplCopyWith(
    _$CommentAuthorImpl value,
    $Res Function(_$CommentAuthorImpl) then,
  ) = __$$CommentAuthorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    @ProfileImageConverter() String? profileImage,
  });
}

/// @nodoc
class __$$CommentAuthorImplCopyWithImpl<$Res>
    extends _$CommentAuthorCopyWithImpl<$Res, _$CommentAuthorImpl>
    implements _$$CommentAuthorImplCopyWith<$Res> {
  __$$CommentAuthorImplCopyWithImpl(
    _$CommentAuthorImpl _value,
    $Res Function(_$CommentAuthorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentAuthor
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
      _$CommentAuthorImpl(
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
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentAuthorImpl
    with DiagnosticableTreeMixin
    implements _CommentAuthor {
  const _$CommentAuthorImpl({
    required this.id,
    required this.firstName,
    required this.lastName,
    @ProfileImageConverter() this.profileImage,
  });

  factory _$CommentAuthorImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentAuthorImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  @ProfileImageConverter()
  final String? profileImage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CommentAuthor(id: $id, firstName: $firstName, lastName: $lastName, profileImage: $profileImage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CommentAuthor'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('firstName', firstName))
      ..add(DiagnosticsProperty('lastName', lastName))
      ..add(DiagnosticsProperty('profileImage', profileImage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentAuthorImpl &&
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

  /// Create a copy of CommentAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentAuthorImplCopyWith<_$CommentAuthorImpl> get copyWith =>
      __$$CommentAuthorImplCopyWithImpl<_$CommentAuthorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentAuthorImplToJson(this);
  }
}

abstract class _CommentAuthor implements CommentAuthor {
  const factory _CommentAuthor({
    required final String id,
    required final String firstName,
    required final String lastName,
    @ProfileImageConverter() final String? profileImage,
  }) = _$CommentAuthorImpl;

  factory _CommentAuthor.fromJson(Map<String, dynamic> json) =
      _$CommentAuthorImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  @ProfileImageConverter()
  String? get profileImage;

  /// Create a copy of CommentAuthor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentAuthorImplCopyWith<_$CommentAuthorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentImage _$CommentImageFromJson(Map<String, dynamic> json) {
  return _CommentImage.fromJson(json);
}

/// @nodoc
mixin _$CommentImage {
  String get publicId => throw _privateConstructorUsedError;
  String get secureUrl => throw _privateConstructorUsedError;

  /// Serializes this CommentImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentImageCopyWith<CommentImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentImageCopyWith<$Res> {
  factory $CommentImageCopyWith(
    CommentImage value,
    $Res Function(CommentImage) then,
  ) = _$CommentImageCopyWithImpl<$Res, CommentImage>;
  @useResult
  $Res call({String publicId, String secureUrl});
}

/// @nodoc
class _$CommentImageCopyWithImpl<$Res, $Val extends CommentImage>
    implements $CommentImageCopyWith<$Res> {
  _$CommentImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentImage
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
abstract class _$$CommentImageImplCopyWith<$Res>
    implements $CommentImageCopyWith<$Res> {
  factory _$$CommentImageImplCopyWith(
    _$CommentImageImpl value,
    $Res Function(_$CommentImageImpl) then,
  ) = __$$CommentImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String publicId, String secureUrl});
}

/// @nodoc
class __$$CommentImageImplCopyWithImpl<$Res>
    extends _$CommentImageCopyWithImpl<$Res, _$CommentImageImpl>
    implements _$$CommentImageImplCopyWith<$Res> {
  __$$CommentImageImplCopyWithImpl(
    _$CommentImageImpl _value,
    $Res Function(_$CommentImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? publicId = null, Object? secureUrl = null}) {
    return _then(
      _$CommentImageImpl(
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
class _$CommentImageImpl with DiagnosticableTreeMixin implements _CommentImage {
  const _$CommentImageImpl({required this.publicId, required this.secureUrl});

  factory _$CommentImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentImageImplFromJson(json);

  @override
  final String publicId;
  @override
  final String secureUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CommentImage(publicId: $publicId, secureUrl: $secureUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CommentImage'))
      ..add(DiagnosticsProperty('publicId', publicId))
      ..add(DiagnosticsProperty('secureUrl', secureUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentImageImpl &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.secureUrl, secureUrl) ||
                other.secureUrl == secureUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, publicId, secureUrl);

  /// Create a copy of CommentImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentImageImplCopyWith<_$CommentImageImpl> get copyWith =>
      __$$CommentImageImplCopyWithImpl<_$CommentImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentImageImplToJson(this);
  }
}

abstract class _CommentImage implements CommentImage {
  const factory _CommentImage({
    required final String publicId,
    required final String secureUrl,
  }) = _$CommentImageImpl;

  factory _CommentImage.fromJson(Map<String, dynamic> json) =
      _$CommentImageImpl.fromJson;

  @override
  String get publicId;
  @override
  String get secureUrl;

  /// Create a copy of CommentImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentImageImplCopyWith<_$CommentImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
