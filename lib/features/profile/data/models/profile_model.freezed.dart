// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return _ProfileModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get company => throw _privateConstructorUsedError;
  int? get pointsBalance => throw _privateConstructorUsedError;
  String? get selfIntroduction => throw _privateConstructorUsedError;
  String? get profession => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;
  ProfileImage? get profileImage => throw _privateConstructorUsedError;
  LocationData? get location => throw _privateConstructorUsedError;

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
    ProfileModel value,
    $Res Function(ProfileModel) then,
  ) = _$ProfileModelCopyWithImpl<$Res, ProfileModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String firstName,
    String lastName,
    String email,
    String phone,
    String address,
    String? company,
    int? pointsBalance,
    String? selfIntroduction,
    String? profession,
    String? role,
    String? status,
    bool? isVerified,
    ProfileImage? profileImage,
    LocationData? location,
  });

  $ProfileImageCopyWith<$Res>? get profileImage;
  $LocationDataCopyWith<$Res>? get location;
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res, $Val extends ProfileModel>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = null,
    Object? address = null,
    Object? company = freezed,
    Object? pointsBalance = freezed,
    Object? selfIntroduction = freezed,
    Object? profession = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? isVerified = freezed,
    Object? profileImage = freezed,
    Object? location = freezed,
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
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            company: freezed == company
                ? _value.company
                : company // ignore: cast_nullable_to_non_nullable
                      as String?,
            pointsBalance: freezed == pointsBalance
                ? _value.pointsBalance
                : pointsBalance // ignore: cast_nullable_to_non_nullable
                      as int?,
            selfIntroduction: freezed == selfIntroduction
                ? _value.selfIntroduction
                : selfIntroduction // ignore: cast_nullable_to_non_nullable
                      as String?,
            profession: freezed == profession
                ? _value.profession
                : profession // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            isVerified: freezed == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool?,
            profileImage: freezed == profileImage
                ? _value.profileImage
                : profileImage // ignore: cast_nullable_to_non_nullable
                      as ProfileImage?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as LocationData?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileImageCopyWith<$Res>? get profileImage {
    if (_value.profileImage == null) {
      return null;
    }

    return $ProfileImageCopyWith<$Res>(_value.profileImage!, (value) {
      return _then(_value.copyWith(profileImage: value) as $Val);
    });
  }

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationDataCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $LocationDataCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileModelImplCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$$ProfileModelImplCopyWith(
    _$ProfileModelImpl value,
    $Res Function(_$ProfileModelImpl) then,
  ) = __$$ProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String firstName,
    String lastName,
    String email,
    String phone,
    String address,
    String? company,
    int? pointsBalance,
    String? selfIntroduction,
    String? profession,
    String? role,
    String? status,
    bool? isVerified,
    ProfileImage? profileImage,
    LocationData? location,
  });

  @override
  $ProfileImageCopyWith<$Res>? get profileImage;
  @override
  $LocationDataCopyWith<$Res>? get location;
}

/// @nodoc
class __$$ProfileModelImplCopyWithImpl<$Res>
    extends _$ProfileModelCopyWithImpl<$Res, _$ProfileModelImpl>
    implements _$$ProfileModelImplCopyWith<$Res> {
  __$$ProfileModelImplCopyWithImpl(
    _$ProfileModelImpl _value,
    $Res Function(_$ProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = null,
    Object? address = null,
    Object? company = freezed,
    Object? pointsBalance = freezed,
    Object? selfIntroduction = freezed,
    Object? profession = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? isVerified = freezed,
    Object? profileImage = freezed,
    Object? location = freezed,
  }) {
    return _then(
      _$ProfileModelImpl(
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
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        company: freezed == company
            ? _value.company
            : company // ignore: cast_nullable_to_non_nullable
                  as String?,
        pointsBalance: freezed == pointsBalance
            ? _value.pointsBalance
            : pointsBalance // ignore: cast_nullable_to_non_nullable
                  as int?,
        selfIntroduction: freezed == selfIntroduction
            ? _value.selfIntroduction
            : selfIntroduction // ignore: cast_nullable_to_non_nullable
                  as String?,
        profession: freezed == profession
            ? _value.profession
            : profession // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        isVerified: freezed == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool?,
        profileImage: freezed == profileImage
            ? _value.profileImage
            : profileImage // ignore: cast_nullable_to_non_nullable
                  as ProfileImage?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as LocationData?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileModelImpl implements _ProfileModel {
  const _$ProfileModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    this.company,
    this.pointsBalance,
    this.selfIntroduction,
    this.profession,
    this.role,
    this.status,
    this.isVerified,
    this.profileImage,
    this.location,
  });

  factory _$ProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String address;
  @override
  final String? company;
  @override
  final int? pointsBalance;
  @override
  final String? selfIntroduction;
  @override
  final String? profession;
  @override
  final String? role;
  @override
  final String? status;
  @override
  final bool? isVerified;
  @override
  final ProfileImage? profileImage;
  @override
  final LocationData? location;

  @override
  String toString() {
    return 'ProfileModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, address: $address, company: $company, pointsBalance: $pointsBalance, selfIntroduction: $selfIntroduction, profession: $profession, role: $role, status: $status, isVerified: $isVerified, profileImage: $profileImage, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.pointsBalance, pointsBalance) ||
                other.pointsBalance == pointsBalance) &&
            (identical(other.selfIntroduction, selfIntroduction) ||
                other.selfIntroduction == selfIntroduction) &&
            (identical(other.profession, profession) ||
                other.profession == profession) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    email,
    phone,
    address,
    company,
    pointsBalance,
    selfIntroduction,
    profession,
    role,
    status,
    isVerified,
    profileImage,
    location,
  );

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      __$$ProfileModelImplCopyWithImpl<_$ProfileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileModelImplToJson(this);
  }
}

abstract class _ProfileModel implements ProfileModel {
  const factory _ProfileModel({
    @JsonKey(name: '_id') required final String id,
    required final String firstName,
    required final String lastName,
    required final String email,
    required final String phone,
    required final String address,
    final String? company,
    final int? pointsBalance,
    final String? selfIntroduction,
    final String? profession,
    final String? role,
    final String? status,
    final bool? isVerified,
    final ProfileImage? profileImage,
    final LocationData? location,
  }) = _$ProfileModelImpl;

  factory _ProfileModel.fromJson(Map<String, dynamic> json) =
      _$ProfileModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get address;
  @override
  String? get company;
  @override
  int? get pointsBalance;
  @override
  String? get selfIntroduction;
  @override
  String? get profession;
  @override
  String? get role;
  @override
  String? get status;
  @override
  bool? get isVerified;
  @override
  ProfileImage? get profileImage;
  @override
  LocationData? get location;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileImage _$ProfileImageFromJson(Map<String, dynamic> json) {
  return _ProfileImage.fromJson(json);
}

/// @nodoc
mixin _$ProfileImage {
  String? get public_id => throw _privateConstructorUsedError;
  String? get secure_url => throw _privateConstructorUsedError;

  /// Serializes this ProfileImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileImageCopyWith<ProfileImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileImageCopyWith<$Res> {
  factory $ProfileImageCopyWith(
    ProfileImage value,
    $Res Function(ProfileImage) then,
  ) = _$ProfileImageCopyWithImpl<$Res, ProfileImage>;
  @useResult
  $Res call({String? public_id, String? secure_url});
}

/// @nodoc
class _$ProfileImageCopyWithImpl<$Res, $Val extends ProfileImage>
    implements $ProfileImageCopyWith<$Res> {
  _$ProfileImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? public_id = freezed, Object? secure_url = freezed}) {
    return _then(
      _value.copyWith(
            public_id: freezed == public_id
                ? _value.public_id
                : public_id // ignore: cast_nullable_to_non_nullable
                      as String?,
            secure_url: freezed == secure_url
                ? _value.secure_url
                : secure_url // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileImageImplCopyWith<$Res>
    implements $ProfileImageCopyWith<$Res> {
  factory _$$ProfileImageImplCopyWith(
    _$ProfileImageImpl value,
    $Res Function(_$ProfileImageImpl) then,
  ) = __$$ProfileImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? public_id, String? secure_url});
}

/// @nodoc
class __$$ProfileImageImplCopyWithImpl<$Res>
    extends _$ProfileImageCopyWithImpl<$Res, _$ProfileImageImpl>
    implements _$$ProfileImageImplCopyWith<$Res> {
  __$$ProfileImageImplCopyWithImpl(
    _$ProfileImageImpl _value,
    $Res Function(_$ProfileImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? public_id = freezed, Object? secure_url = freezed}) {
    return _then(
      _$ProfileImageImpl(
        public_id: freezed == public_id
            ? _value.public_id
            : public_id // ignore: cast_nullable_to_non_nullable
                  as String?,
        secure_url: freezed == secure_url
            ? _value.secure_url
            : secure_url // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileImageImpl implements _ProfileImage {
  const _$ProfileImageImpl({this.public_id, this.secure_url});

  factory _$ProfileImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImageImplFromJson(json);

  @override
  final String? public_id;
  @override
  final String? secure_url;

  @override
  String toString() {
    return 'ProfileImage(public_id: $public_id, secure_url: $secure_url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImageImpl &&
            (identical(other.public_id, public_id) ||
                other.public_id == public_id) &&
            (identical(other.secure_url, secure_url) ||
                other.secure_url == secure_url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, public_id, secure_url);

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImageImplCopyWith<_$ProfileImageImpl> get copyWith =>
      __$$ProfileImageImplCopyWithImpl<_$ProfileImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImageImplToJson(this);
  }
}

abstract class _ProfileImage implements ProfileImage {
  const factory _ProfileImage({
    final String? public_id,
    final String? secure_url,
  }) = _$ProfileImageImpl;

  factory _ProfileImage.fromJson(Map<String, dynamic> json) =
      _$ProfileImageImpl.fromJson;

  @override
  String? get public_id;
  @override
  String? get secure_url;

  /// Create a copy of ProfileImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileImageImplCopyWith<_$ProfileImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationData _$LocationDataFromJson(Map<String, dynamic> json) {
  return _LocationData.fromJson(json);
}

/// @nodoc
mixin _$LocationData {
  String? get type => throw _privateConstructorUsedError;
  List<double>? get coordinates => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this LocationData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationDataCopyWith<LocationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationDataCopyWith<$Res> {
  factory $LocationDataCopyWith(
    LocationData value,
    $Res Function(LocationData) then,
  ) = _$LocationDataCopyWithImpl<$Res, LocationData>;
  @useResult
  $Res call({String? type, List<double>? coordinates, String? address});
}

/// @nodoc
class _$LocationDataCopyWithImpl<$Res, $Val extends LocationData>
    implements $LocationDataCopyWith<$Res> {
  _$LocationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? coordinates = freezed,
    Object? address = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            coordinates: freezed == coordinates
                ? _value.coordinates
                : coordinates // ignore: cast_nullable_to_non_nullable
                      as List<double>?,
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
abstract class _$$LocationDataImplCopyWith<$Res>
    implements $LocationDataCopyWith<$Res> {
  factory _$$LocationDataImplCopyWith(
    _$LocationDataImpl value,
    $Res Function(_$LocationDataImpl) then,
  ) = __$$LocationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? type, List<double>? coordinates, String? address});
}

/// @nodoc
class __$$LocationDataImplCopyWithImpl<$Res>
    extends _$LocationDataCopyWithImpl<$Res, _$LocationDataImpl>
    implements _$$LocationDataImplCopyWith<$Res> {
  __$$LocationDataImplCopyWithImpl(
    _$LocationDataImpl _value,
    $Res Function(_$LocationDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? coordinates = freezed,
    Object? address = freezed,
  }) {
    return _then(
      _$LocationDataImpl(
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        coordinates: freezed == coordinates
            ? _value._coordinates
            : coordinates // ignore: cast_nullable_to_non_nullable
                  as List<double>?,
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
class _$LocationDataImpl implements _LocationData {
  const _$LocationDataImpl({
    this.type,
    final List<double>? coordinates,
    this.address,
  }) : _coordinates = coordinates;

  factory _$LocationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationDataImplFromJson(json);

  @override
  final String? type;
  final List<double>? _coordinates;
  @override
  List<double>? get coordinates {
    final value = _coordinates;
    if (value == null) return null;
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? address;

  @override
  String toString() {
    return 'LocationData(type: $type, coordinates: $coordinates, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationDataImpl &&
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

  /// Create a copy of LocationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationDataImplCopyWith<_$LocationDataImpl> get copyWith =>
      __$$LocationDataImplCopyWithImpl<_$LocationDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationDataImplToJson(this);
  }
}

abstract class _LocationData implements LocationData {
  const factory _LocationData({
    final String? type,
    final List<double>? coordinates,
    final String? address,
  }) = _$LocationDataImpl;

  factory _LocationData.fromJson(Map<String, dynamic> json) =
      _$LocationDataImpl.fromJson;

  @override
  String? get type;
  @override
  List<double>? get coordinates;
  @override
  String? get address;

  /// Create a copy of LocationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationDataImplCopyWith<_$LocationDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
