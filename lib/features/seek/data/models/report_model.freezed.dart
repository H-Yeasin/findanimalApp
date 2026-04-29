// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) {
  return _ReportModel.fromJson(json);
}

/// @nodoc
mixin _$ReportModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get animalName => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String get species => throw _privateConstructorUsedError;
  String get breed => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String get age => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get eventDate => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<ReportImage> get images => throw _privateConstructorUsedError;
  String get hasMicrochip => throw _privateConstructorUsedError;
  String get hasTattoo => throw _privateConstructorUsedError;
  String get hasCollarOrHarness => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  bool get isPhoneVisible => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  bool get isEmailVisible => throw _privateConstructorUsedError;
  ReportLocation get location => throw _privateConstructorUsedError;
  ReportAuthor? get author => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReportModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportModelCopyWith<ReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportModelCopyWith<$Res> {
  factory $ReportModelCopyWith(
    ReportModel value,
    $Res Function(ReportModel) then,
  ) = _$ReportModelCopyWithImpl<$Res, ReportModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String animalName,
    String? title,
    String species,
    String breed,
    String gender,
    String age,
    String status,
    DateTime eventDate,
    String description,
    List<ReportImage> images,
    String hasMicrochip,
    String hasTattoo,
    String hasCollarOrHarness,
    String? contactPhone,
    bool isPhoneVisible,
    String? contactEmail,
    bool isEmailVisible,
    ReportLocation location,
    ReportAuthor? author,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $ReportLocationCopyWith<$Res> get location;
  $ReportAuthorCopyWith<$Res>? get author;
}

/// @nodoc
class _$ReportModelCopyWithImpl<$Res, $Val extends ReportModel>
    implements $ReportModelCopyWith<$Res> {
  _$ReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? animalName = null,
    Object? title = freezed,
    Object? species = null,
    Object? breed = null,
    Object? gender = null,
    Object? age = null,
    Object? status = null,
    Object? eventDate = null,
    Object? description = null,
    Object? images = null,
    Object? hasMicrochip = null,
    Object? hasTattoo = null,
    Object? hasCollarOrHarness = null,
    Object? contactPhone = freezed,
    Object? isPhoneVisible = null,
    Object? contactEmail = freezed,
    Object? isEmailVisible = null,
    Object? location = null,
    Object? author = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            animalName: null == animalName
                ? _value.animalName
                : animalName // ignore: cast_nullable_to_non_nullable
                      as String,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            species: null == species
                ? _value.species
                : species // ignore: cast_nullable_to_non_nullable
                      as String,
            breed: null == breed
                ? _value.breed
                : breed // ignore: cast_nullable_to_non_nullable
                      as String,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String,
            age: null == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            eventDate: null == eventDate
                ? _value.eventDate
                : eventDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<ReportImage>,
            hasMicrochip: null == hasMicrochip
                ? _value.hasMicrochip
                : hasMicrochip // ignore: cast_nullable_to_non_nullable
                      as String,
            hasTattoo: null == hasTattoo
                ? _value.hasTattoo
                : hasTattoo // ignore: cast_nullable_to_non_nullable
                      as String,
            hasCollarOrHarness: null == hasCollarOrHarness
                ? _value.hasCollarOrHarness
                : hasCollarOrHarness // ignore: cast_nullable_to_non_nullable
                      as String,
            contactPhone: freezed == contactPhone
                ? _value.contactPhone
                : contactPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPhoneVisible: null == isPhoneVisible
                ? _value.isPhoneVisible
                : isPhoneVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            contactEmail: freezed == contactEmail
                ? _value.contactEmail
                : contactEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            isEmailVisible: null == isEmailVisible
                ? _value.isEmailVisible
                : isEmailVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as ReportLocation,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as ReportAuthor?,
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

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReportLocationCopyWith<$Res> get location {
    return $ReportLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReportAuthorCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $ReportAuthorCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReportModelImplCopyWith<$Res>
    implements $ReportModelCopyWith<$Res> {
  factory _$$ReportModelImplCopyWith(
    _$ReportModelImpl value,
    $Res Function(_$ReportModelImpl) then,
  ) = __$$ReportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String animalName,
    String? title,
    String species,
    String breed,
    String gender,
    String age,
    String status,
    DateTime eventDate,
    String description,
    List<ReportImage> images,
    String hasMicrochip,
    String hasTattoo,
    String hasCollarOrHarness,
    String? contactPhone,
    bool isPhoneVisible,
    String? contactEmail,
    bool isEmailVisible,
    ReportLocation location,
    ReportAuthor? author,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $ReportLocationCopyWith<$Res> get location;
  @override
  $ReportAuthorCopyWith<$Res>? get author;
}

/// @nodoc
class __$$ReportModelImplCopyWithImpl<$Res>
    extends _$ReportModelCopyWithImpl<$Res, _$ReportModelImpl>
    implements _$$ReportModelImplCopyWith<$Res> {
  __$$ReportModelImplCopyWithImpl(
    _$ReportModelImpl _value,
    $Res Function(_$ReportModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? animalName = null,
    Object? title = freezed,
    Object? species = null,
    Object? breed = null,
    Object? gender = null,
    Object? age = null,
    Object? status = null,
    Object? eventDate = null,
    Object? description = null,
    Object? images = null,
    Object? hasMicrochip = null,
    Object? hasTattoo = null,
    Object? hasCollarOrHarness = null,
    Object? contactPhone = freezed,
    Object? isPhoneVisible = null,
    Object? contactEmail = freezed,
    Object? isEmailVisible = null,
    Object? location = null,
    Object? author = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ReportModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        animalName: null == animalName
            ? _value.animalName
            : animalName // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        species: null == species
            ? _value.species
            : species // ignore: cast_nullable_to_non_nullable
                  as String,
        breed: null == breed
            ? _value.breed
            : breed // ignore: cast_nullable_to_non_nullable
                  as String,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String,
        age: null == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        eventDate: null == eventDate
            ? _value.eventDate
            : eventDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<ReportImage>,
        hasMicrochip: null == hasMicrochip
            ? _value.hasMicrochip
            : hasMicrochip // ignore: cast_nullable_to_non_nullable
                  as String,
        hasTattoo: null == hasTattoo
            ? _value.hasTattoo
            : hasTattoo // ignore: cast_nullable_to_non_nullable
                  as String,
        hasCollarOrHarness: null == hasCollarOrHarness
            ? _value.hasCollarOrHarness
            : hasCollarOrHarness // ignore: cast_nullable_to_non_nullable
                  as String,
        contactPhone: freezed == contactPhone
            ? _value.contactPhone
            : contactPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPhoneVisible: null == isPhoneVisible
            ? _value.isPhoneVisible
            : isPhoneVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        contactEmail: freezed == contactEmail
            ? _value.contactEmail
            : contactEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        isEmailVisible: null == isEmailVisible
            ? _value.isEmailVisible
            : isEmailVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as ReportLocation,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as ReportAuthor?,
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
class _$ReportModelImpl implements _ReportModel {
  const _$ReportModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.animalName,
    this.title,
    required this.species,
    required this.breed,
    required this.gender,
    required this.age,
    required this.status,
    required this.eventDate,
    required this.description,
    required final List<ReportImage> images,
    required this.hasMicrochip,
    required this.hasTattoo,
    required this.hasCollarOrHarness,
    this.contactPhone,
    this.isPhoneVisible = false,
    this.contactEmail,
    this.isEmailVisible = false,
    required this.location,
    this.author,
    this.createdAt,
    this.updatedAt,
  }) : _images = images;

  factory _$ReportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String animalName;
  @override
  final String? title;
  @override
  final String species;
  @override
  final String breed;
  @override
  final String gender;
  @override
  final String age;
  @override
  final String status;
  @override
  final DateTime eventDate;
  @override
  final String description;
  final List<ReportImage> _images;
  @override
  List<ReportImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String hasMicrochip;
  @override
  final String hasTattoo;
  @override
  final String hasCollarOrHarness;
  @override
  final String? contactPhone;
  @override
  @JsonKey()
  final bool isPhoneVisible;
  @override
  final String? contactEmail;
  @override
  @JsonKey()
  final bool isEmailVisible;
  @override
  final ReportLocation location;
  @override
  final ReportAuthor? author;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ReportModel(id: $id, animalName: $animalName, title: $title, species: $species, breed: $breed, gender: $gender, age: $age, status: $status, eventDate: $eventDate, description: $description, images: $images, hasMicrochip: $hasMicrochip, hasTattoo: $hasTattoo, hasCollarOrHarness: $hasCollarOrHarness, contactPhone: $contactPhone, isPhoneVisible: $isPhoneVisible, contactEmail: $contactEmail, isEmailVisible: $isEmailVisible, location: $location, author: $author, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.animalName, animalName) ||
                other.animalName == animalName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.species, species) || other.species == species) &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.hasMicrochip, hasMicrochip) ||
                other.hasMicrochip == hasMicrochip) &&
            (identical(other.hasTattoo, hasTattoo) ||
                other.hasTattoo == hasTattoo) &&
            (identical(other.hasCollarOrHarness, hasCollarOrHarness) ||
                other.hasCollarOrHarness == hasCollarOrHarness) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.isPhoneVisible, isPhoneVisible) ||
                other.isPhoneVisible == isPhoneVisible) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.isEmailVisible, isEmailVisible) ||
                other.isEmailVisible == isEmailVisible) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    animalName,
    title,
    species,
    breed,
    gender,
    age,
    status,
    eventDate,
    description,
    const DeepCollectionEquality().hash(_images),
    hasMicrochip,
    hasTattoo,
    hasCollarOrHarness,
    contactPhone,
    isPhoneVisible,
    contactEmail,
    isEmailVisible,
    location,
    author,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportModelImplCopyWith<_$ReportModelImpl> get copyWith =>
      __$$ReportModelImplCopyWithImpl<_$ReportModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportModelImplToJson(this);
  }
}

abstract class _ReportModel implements ReportModel {
  const factory _ReportModel({
    @JsonKey(name: '_id') required final String id,
    required final String animalName,
    final String? title,
    required final String species,
    required final String breed,
    required final String gender,
    required final String age,
    required final String status,
    required final DateTime eventDate,
    required final String description,
    required final List<ReportImage> images,
    required final String hasMicrochip,
    required final String hasTattoo,
    required final String hasCollarOrHarness,
    final String? contactPhone,
    final bool isPhoneVisible,
    final String? contactEmail,
    final bool isEmailVisible,
    required final ReportLocation location,
    final ReportAuthor? author,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ReportModelImpl;

  factory _ReportModel.fromJson(Map<String, dynamic> json) =
      _$ReportModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get animalName;
  @override
  String? get title;
  @override
  String get species;
  @override
  String get breed;
  @override
  String get gender;
  @override
  String get age;
  @override
  String get status;
  @override
  DateTime get eventDate;
  @override
  String get description;
  @override
  List<ReportImage> get images;
  @override
  String get hasMicrochip;
  @override
  String get hasTattoo;
  @override
  String get hasCollarOrHarness;
  @override
  String? get contactPhone;
  @override
  bool get isPhoneVisible;
  @override
  String? get contactEmail;
  @override
  bool get isEmailVisible;
  @override
  ReportLocation get location;
  @override
  ReportAuthor? get author;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportModelImplCopyWith<_$ReportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportAuthor _$ReportAuthorFromJson(Map<String, dynamic> json) {
  return _ReportAuthor.fromJson(json);
}

/// @nodoc
mixin _$ReportAuthor {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this ReportAuthor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportAuthorCopyWith<ReportAuthor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportAuthorCopyWith<$Res> {
  factory $ReportAuthorCopyWith(
    ReportAuthor value,
    $Res Function(ReportAuthor) then,
  ) = _$ReportAuthorCopyWithImpl<$Res, ReportAuthor>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String firstName,
    String lastName,
    String? email,
  });
}

/// @nodoc
class _$ReportAuthorCopyWithImpl<$Res, $Val extends ReportAuthor>
    implements $ReportAuthorCopyWith<$Res> {
  _$ReportAuthorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
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
abstract class _$$ReportAuthorImplCopyWith<$Res>
    implements $ReportAuthorCopyWith<$Res> {
  factory _$$ReportAuthorImplCopyWith(
    _$ReportAuthorImpl value,
    $Res Function(_$ReportAuthorImpl) then,
  ) = __$$ReportAuthorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String firstName,
    String lastName,
    String? email,
  });
}

/// @nodoc
class __$$ReportAuthorImplCopyWithImpl<$Res>
    extends _$ReportAuthorCopyWithImpl<$Res, _$ReportAuthorImpl>
    implements _$$ReportAuthorImplCopyWith<$Res> {
  __$$ReportAuthorImplCopyWithImpl(
    _$ReportAuthorImpl _value,
    $Res Function(_$ReportAuthorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
  }) {
    return _then(
      _$ReportAuthorImpl(
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
class _$ReportAuthorImpl implements _ReportAuthor {
  const _$ReportAuthorImpl({
    @JsonKey(name: '_id') required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
  });

  factory _$ReportAuthorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportAuthorImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? email;

  @override
  String toString() {
    return 'ReportAuthor(id: $id, firstName: $firstName, lastName: $lastName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportAuthorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, firstName, lastName, email);

  /// Create a copy of ReportAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportAuthorImplCopyWith<_$ReportAuthorImpl> get copyWith =>
      __$$ReportAuthorImplCopyWithImpl<_$ReportAuthorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportAuthorImplToJson(this);
  }
}

abstract class _ReportAuthor implements ReportAuthor {
  const factory _ReportAuthor({
    @JsonKey(name: '_id') required final String id,
    required final String firstName,
    required final String lastName,
    final String? email,
  }) = _$ReportAuthorImpl;

  factory _ReportAuthor.fromJson(Map<String, dynamic> json) =
      _$ReportAuthorImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get email;

  /// Create a copy of ReportAuthor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportAuthorImplCopyWith<_$ReportAuthorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportImage _$ReportImageFromJson(Map<String, dynamic> json) {
  return _ReportImage.fromJson(json);
}

/// @nodoc
mixin _$ReportImage {
  @JsonKey(name: 'public_id')
  String get publicId => throw _privateConstructorUsedError;
  @JsonKey(name: 'secure_url')
  String get secureUrl => throw _privateConstructorUsedError;
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this ReportImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportImageCopyWith<ReportImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportImageCopyWith<$Res> {
  factory $ReportImageCopyWith(
    ReportImage value,
    $Res Function(ReportImage) then,
  ) = _$ReportImageCopyWithImpl<$Res, ReportImage>;
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    @JsonKey(name: 'secure_url') String secureUrl,
    @JsonKey(name: '_id') String? id,
  });
}

/// @nodoc
class _$ReportImageCopyWithImpl<$Res, $Val extends ReportImage>
    implements $ReportImageCopyWith<$Res> {
  _$ReportImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicId = null,
    Object? secureUrl = null,
    Object? id = freezed,
  }) {
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
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportImageImplCopyWith<$Res>
    implements $ReportImageCopyWith<$Res> {
  factory _$$ReportImageImplCopyWith(
    _$ReportImageImpl value,
    $Res Function(_$ReportImageImpl) then,
  ) = __$$ReportImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    @JsonKey(name: 'secure_url') String secureUrl,
    @JsonKey(name: '_id') String? id,
  });
}

/// @nodoc
class __$$ReportImageImplCopyWithImpl<$Res>
    extends _$ReportImageCopyWithImpl<$Res, _$ReportImageImpl>
    implements _$$ReportImageImplCopyWith<$Res> {
  __$$ReportImageImplCopyWithImpl(
    _$ReportImageImpl _value,
    $Res Function(_$ReportImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicId = null,
    Object? secureUrl = null,
    Object? id = freezed,
  }) {
    return _then(
      _$ReportImageImpl(
        publicId: null == publicId
            ? _value.publicId
            : publicId // ignore: cast_nullable_to_non_nullable
                  as String,
        secureUrl: null == secureUrl
            ? _value.secureUrl
            : secureUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportImageImpl implements _ReportImage {
  const _$ReportImageImpl({
    @JsonKey(name: 'public_id') required this.publicId,
    @JsonKey(name: 'secure_url') required this.secureUrl,
    @JsonKey(name: '_id') this.id,
  });

  factory _$ReportImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportImageImplFromJson(json);

  @override
  @JsonKey(name: 'public_id')
  final String publicId;
  @override
  @JsonKey(name: 'secure_url')
  final String secureUrl;
  @override
  @JsonKey(name: '_id')
  final String? id;

  @override
  String toString() {
    return 'ReportImage(publicId: $publicId, secureUrl: $secureUrl, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportImageImpl &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.secureUrl, secureUrl) ||
                other.secureUrl == secureUrl) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, publicId, secureUrl, id);

  /// Create a copy of ReportImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportImageImplCopyWith<_$ReportImageImpl> get copyWith =>
      __$$ReportImageImplCopyWithImpl<_$ReportImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportImageImplToJson(this);
  }
}

abstract class _ReportImage implements ReportImage {
  const factory _ReportImage({
    @JsonKey(name: 'public_id') required final String publicId,
    @JsonKey(name: 'secure_url') required final String secureUrl,
    @JsonKey(name: '_id') final String? id,
  }) = _$ReportImageImpl;

  factory _ReportImage.fromJson(Map<String, dynamic> json) =
      _$ReportImageImpl.fromJson;

  @override
  @JsonKey(name: 'public_id')
  String get publicId;
  @override
  @JsonKey(name: 'secure_url')
  String get secureUrl;
  @override
  @JsonKey(name: '_id')
  String? get id;

  /// Create a copy of ReportImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportImageImplCopyWith<_$ReportImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportLocation _$ReportLocationFromJson(Map<String, dynamic> json) {
  return _ReportLocation.fromJson(json);
}

/// @nodoc
mixin _$ReportLocation {
  String get type => throw _privateConstructorUsedError;
  List<double> get coordinates => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;

  /// Serializes this ReportLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportLocationCopyWith<ReportLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportLocationCopyWith<$Res> {
  factory $ReportLocationCopyWith(
    ReportLocation value,
    $Res Function(ReportLocation) then,
  ) = _$ReportLocationCopyWithImpl<$Res, ReportLocation>;
  @useResult
  $Res call({String type, List<double> coordinates, String address});
}

/// @nodoc
class _$ReportLocationCopyWithImpl<$Res, $Val extends ReportLocation>
    implements $ReportLocationCopyWith<$Res> {
  _$ReportLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
    Object? address = null,
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
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportLocationImplCopyWith<$Res>
    implements $ReportLocationCopyWith<$Res> {
  factory _$$ReportLocationImplCopyWith(
    _$ReportLocationImpl value,
    $Res Function(_$ReportLocationImpl) then,
  ) = __$$ReportLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, List<double> coordinates, String address});
}

/// @nodoc
class __$$ReportLocationImplCopyWithImpl<$Res>
    extends _$ReportLocationCopyWithImpl<$Res, _$ReportLocationImpl>
    implements _$$ReportLocationImplCopyWith<$Res> {
  __$$ReportLocationImplCopyWithImpl(
    _$ReportLocationImpl _value,
    $Res Function(_$ReportLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
    Object? address = null,
  }) {
    return _then(
      _$ReportLocationImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        coordinates: null == coordinates
            ? _value._coordinates
            : coordinates // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportLocationImpl implements _ReportLocation {
  const _$ReportLocationImpl({
    required this.type,
    required final List<double> coordinates,
    required this.address,
  }) : _coordinates = coordinates;

  factory _$ReportLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportLocationImplFromJson(json);

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
  final String address;

  @override
  String toString() {
    return 'ReportLocation(type: $type, coordinates: $coordinates, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportLocationImpl &&
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

  /// Create a copy of ReportLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportLocationImplCopyWith<_$ReportLocationImpl> get copyWith =>
      __$$ReportLocationImplCopyWithImpl<_$ReportLocationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportLocationImplToJson(this);
  }
}

abstract class _ReportLocation implements ReportLocation {
  const factory _ReportLocation({
    required final String type,
    required final List<double> coordinates,
    required final String address,
  }) = _$ReportLocationImpl;

  factory _ReportLocation.fromJson(Map<String, dynamic> json) =
      _$ReportLocationImpl.fromJson;

  @override
  String get type;
  @override
  List<double> get coordinates;
  @override
  String get address;

  /// Create a copy of ReportLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportLocationImplCopyWith<_$ReportLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
