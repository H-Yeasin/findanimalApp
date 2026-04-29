// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MissionModel _$MissionModelFromJson(Map<String, dynamic> json) {
  return _MissionModel.fromJson(json);
}

/// @nodoc
mixin _$MissionModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get duration => throw _privateConstructorUsedError;
  int? get points => throw _privateConstructorUsedError;
  MissionPhoto? get photo => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  MissionPartner? get partner => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MissionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MissionModelCopyWith<MissionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionModelCopyWith<$Res> {
  factory $MissionModelCopyWith(
    MissionModel value,
    $Res Function(MissionModel) then,
  ) = _$MissionModelCopyWithImpl<$Res, MissionModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String description,
    String address,
    String duration,
    int? points,
    MissionPhoto? photo,
    String status,
    MissionPartner? partner,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $MissionPhotoCopyWith<$Res>? get photo;
  $MissionPartnerCopyWith<$Res>? get partner;
}

/// @nodoc
class _$MissionModelCopyWithImpl<$Res, $Val extends MissionModel>
    implements $MissionModelCopyWith<$Res> {
  _$MissionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? address = null,
    Object? duration = null,
    Object? points = freezed,
    Object? photo = freezed,
    Object? status = null,
    Object? partner = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String,
            points: freezed == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int?,
            photo: freezed == photo
                ? _value.photo
                : photo // ignore: cast_nullable_to_non_nullable
                      as MissionPhoto?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            partner: freezed == partner
                ? _value.partner
                : partner // ignore: cast_nullable_to_non_nullable
                      as MissionPartner?,
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

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MissionPhotoCopyWith<$Res>? get photo {
    if (_value.photo == null) {
      return null;
    }

    return $MissionPhotoCopyWith<$Res>(_value.photo!, (value) {
      return _then(_value.copyWith(photo: value) as $Val);
    });
  }

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MissionPartnerCopyWith<$Res>? get partner {
    if (_value.partner == null) {
      return null;
    }

    return $MissionPartnerCopyWith<$Res>(_value.partner!, (value) {
      return _then(_value.copyWith(partner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MissionModelImplCopyWith<$Res>
    implements $MissionModelCopyWith<$Res> {
  factory _$$MissionModelImplCopyWith(
    _$MissionModelImpl value,
    $Res Function(_$MissionModelImpl) then,
  ) = __$$MissionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String description,
    String address,
    String duration,
    int? points,
    MissionPhoto? photo,
    String status,
    MissionPartner? partner,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $MissionPhotoCopyWith<$Res>? get photo;
  @override
  $MissionPartnerCopyWith<$Res>? get partner;
}

/// @nodoc
class __$$MissionModelImplCopyWithImpl<$Res>
    extends _$MissionModelCopyWithImpl<$Res, _$MissionModelImpl>
    implements _$$MissionModelImplCopyWith<$Res> {
  __$$MissionModelImplCopyWithImpl(
    _$MissionModelImpl _value,
    $Res Function(_$MissionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? address = null,
    Object? duration = null,
    Object? points = freezed,
    Object? photo = freezed,
    Object? status = null,
    Object? partner = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$MissionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        points: freezed == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int?,
        photo: freezed == photo
            ? _value.photo
            : photo // ignore: cast_nullable_to_non_nullable
                  as MissionPhoto?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        partner: freezed == partner
            ? _value.partner
            : partner // ignore: cast_nullable_to_non_nullable
                  as MissionPartner?,
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
class _$MissionModelImpl implements _MissionModel {
  const _$MissionModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.duration,
    this.points,
    this.photo,
    required this.status,
    this.partner,
    this.createdAt,
    this.updatedAt,
  });

  factory _$MissionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String address;
  @override
  final String duration;
  @override
  final int? points;
  @override
  final MissionPhoto? photo;
  @override
  final String status;
  @override
  final MissionPartner? partner;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MissionModel(id: $id, title: $title, description: $description, address: $address, duration: $duration, points: $points, photo: $photo, status: $status, partner: $partner, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.partner, partner) || other.partner == partner) &&
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
    title,
    description,
    address,
    duration,
    points,
    photo,
    status,
    partner,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionModelImplCopyWith<_$MissionModelImpl> get copyWith =>
      __$$MissionModelImplCopyWithImpl<_$MissionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionModelImplToJson(this);
  }
}

abstract class _MissionModel implements MissionModel {
  const factory _MissionModel({
    @JsonKey(name: '_id') required final String id,
    required final String title,
    required final String description,
    required final String address,
    required final String duration,
    final int? points,
    final MissionPhoto? photo,
    required final String status,
    final MissionPartner? partner,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$MissionModelImpl;

  factory _MissionModel.fromJson(Map<String, dynamic> json) =
      _$MissionModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get address;
  @override
  String get duration;
  @override
  int? get points;
  @override
  MissionPhoto? get photo;
  @override
  String get status;
  @override
  MissionPartner? get partner;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of MissionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MissionModelImplCopyWith<_$MissionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MissionPhoto _$MissionPhotoFromJson(Map<String, dynamic> json) {
  return _MissionPhoto.fromJson(json);
}

/// @nodoc
mixin _$MissionPhoto {
  @JsonKey(name: 'public_id')
  String get publicId => throw _privateConstructorUsedError;
  @JsonKey(name: 'secure_url')
  String get secureUrl => throw _privateConstructorUsedError;

  /// Serializes this MissionPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MissionPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MissionPhotoCopyWith<MissionPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionPhotoCopyWith<$Res> {
  factory $MissionPhotoCopyWith(
    MissionPhoto value,
    $Res Function(MissionPhoto) then,
  ) = _$MissionPhotoCopyWithImpl<$Res, MissionPhoto>;
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    @JsonKey(name: 'secure_url') String secureUrl,
  });
}

/// @nodoc
class _$MissionPhotoCopyWithImpl<$Res, $Val extends MissionPhoto>
    implements $MissionPhotoCopyWith<$Res> {
  _$MissionPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MissionPhoto
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
abstract class _$$MissionPhotoImplCopyWith<$Res>
    implements $MissionPhotoCopyWith<$Res> {
  factory _$$MissionPhotoImplCopyWith(
    _$MissionPhotoImpl value,
    $Res Function(_$MissionPhotoImpl) then,
  ) = __$$MissionPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    @JsonKey(name: 'secure_url') String secureUrl,
  });
}

/// @nodoc
class __$$MissionPhotoImplCopyWithImpl<$Res>
    extends _$MissionPhotoCopyWithImpl<$Res, _$MissionPhotoImpl>
    implements _$$MissionPhotoImplCopyWith<$Res> {
  __$$MissionPhotoImplCopyWithImpl(
    _$MissionPhotoImpl _value,
    $Res Function(_$MissionPhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MissionPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? publicId = null, Object? secureUrl = null}) {
    return _then(
      _$MissionPhotoImpl(
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
class _$MissionPhotoImpl implements _MissionPhoto {
  const _$MissionPhotoImpl({
    @JsonKey(name: 'public_id') required this.publicId,
    @JsonKey(name: 'secure_url') required this.secureUrl,
  });

  factory _$MissionPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionPhotoImplFromJson(json);

  @override
  @JsonKey(name: 'public_id')
  final String publicId;
  @override
  @JsonKey(name: 'secure_url')
  final String secureUrl;

  @override
  String toString() {
    return 'MissionPhoto(publicId: $publicId, secureUrl: $secureUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionPhotoImpl &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.secureUrl, secureUrl) ||
                other.secureUrl == secureUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, publicId, secureUrl);

  /// Create a copy of MissionPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionPhotoImplCopyWith<_$MissionPhotoImpl> get copyWith =>
      __$$MissionPhotoImplCopyWithImpl<_$MissionPhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionPhotoImplToJson(this);
  }
}

abstract class _MissionPhoto implements MissionPhoto {
  const factory _MissionPhoto({
    @JsonKey(name: 'public_id') required final String publicId,
    @JsonKey(name: 'secure_url') required final String secureUrl,
  }) = _$MissionPhotoImpl;

  factory _MissionPhoto.fromJson(Map<String, dynamic> json) =
      _$MissionPhotoImpl.fromJson;

  @override
  @JsonKey(name: 'public_id')
  String get publicId;
  @override
  @JsonKey(name: 'secure_url')
  String get secureUrl;

  /// Create a copy of MissionPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MissionPhotoImplCopyWith<_$MissionPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MissionPartner _$MissionPartnerFromJson(Map<String, dynamic> json) {
  return _MissionPartner.fromJson(json);
}

/// @nodoc
mixin _$MissionPartner {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get company => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this MissionPartner to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MissionPartner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MissionPartnerCopyWith<MissionPartner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionPartnerCopyWith<$Res> {
  factory $MissionPartnerCopyWith(
    MissionPartner value,
    $Res Function(MissionPartner) then,
  ) = _$MissionPartnerCopyWithImpl<$Res, MissionPartner>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String firstName,
    String lastName,
    String? company,
    String? email,
  });
}

/// @nodoc
class _$MissionPartnerCopyWithImpl<$Res, $Val extends MissionPartner>
    implements $MissionPartnerCopyWith<$Res> {
  _$MissionPartnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MissionPartner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? company = freezed,
    Object? email = freezed,
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
            company: freezed == company
                ? _value.company
                : company // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MissionPartnerImplCopyWith<$Res>
    implements $MissionPartnerCopyWith<$Res> {
  factory _$$MissionPartnerImplCopyWith(
    _$MissionPartnerImpl value,
    $Res Function(_$MissionPartnerImpl) then,
  ) = __$$MissionPartnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String firstName,
    String lastName,
    String? company,
    String? email,
  });
}

/// @nodoc
class __$$MissionPartnerImplCopyWithImpl<$Res>
    extends _$MissionPartnerCopyWithImpl<$Res, _$MissionPartnerImpl>
    implements _$$MissionPartnerImplCopyWith<$Res> {
  __$$MissionPartnerImplCopyWithImpl(
    _$MissionPartnerImpl _value,
    $Res Function(_$MissionPartnerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MissionPartner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? company = freezed,
    Object? email = freezed,
  }) {
    return _then(
      _$MissionPartnerImpl(
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
        company: freezed == company
            ? _value.company
            : company // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionPartnerImpl implements _MissionPartner {
  const _$MissionPartnerImpl({
    @JsonKey(name: '_id') required this.id,
    required this.firstName,
    required this.lastName,
    this.company,
    this.email,
  });

  factory _$MissionPartnerImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionPartnerImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? company;
  @override
  final String? email;

  @override
  String toString() {
    return 'MissionPartner(id: $id, firstName: $firstName, lastName: $lastName, company: $company, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionPartnerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, firstName, lastName, company, email);

  /// Create a copy of MissionPartner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionPartnerImplCopyWith<_$MissionPartnerImpl> get copyWith =>
      __$$MissionPartnerImplCopyWithImpl<_$MissionPartnerImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionPartnerImplToJson(this);
  }
}

abstract class _MissionPartner implements MissionPartner {
  const factory _MissionPartner({
    @JsonKey(name: '_id') required final String id,
    required final String firstName,
    required final String lastName,
    final String? company,
    final String? email,
  }) = _$MissionPartnerImpl;

  factory _MissionPartner.fromJson(Map<String, dynamic> json) =
      _$MissionPartnerImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get company;
  @override
  String? get email;

  /// Create a copy of MissionPartner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MissionPartnerImplCopyWith<_$MissionPartnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
