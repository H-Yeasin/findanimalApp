// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportModelImpl _$$ReportModelImplFromJson(Map<String, dynamic> json) =>
    _$ReportModelImpl(
      id: json['_id'] as String,
      animalName: json['animalName'] as String,
      title: json['title'] as String?,
      species: json['species'] as String,
      breed: json['breed'] as String,
      gender: json['gender'] as String,
      age: json['age'] as String,
      status: json['status'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      description: json['description'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => ReportImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMicrochip: json['hasMicrochip'] as String,
      hasTattoo: json['hasTattoo'] as String,
      hasCollarOrHarness: json['hasCollarOrHarness'] as String,
      contactPhone: json['contactPhone'] as String?,
      isPhoneVisible: json['isPhoneVisible'] as bool? ?? false,
      contactEmail: json['contactEmail'] as String?,
      isEmailVisible: json['isEmailVisible'] as bool? ?? false,
      location: ReportLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      author: json['author'] == null
          ? null
          : ReportAuthor.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReportModelImplToJson(_$ReportModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'animalName': instance.animalName,
      'title': instance.title,
      'species': instance.species,
      'breed': instance.breed,
      'gender': instance.gender,
      'age': instance.age,
      'status': instance.status,
      'eventDate': instance.eventDate.toIso8601String(),
      'description': instance.description,
      'images': instance.images,
      'hasMicrochip': instance.hasMicrochip,
      'hasTattoo': instance.hasTattoo,
      'hasCollarOrHarness': instance.hasCollarOrHarness,
      'contactPhone': instance.contactPhone,
      'isPhoneVisible': instance.isPhoneVisible,
      'contactEmail': instance.contactEmail,
      'isEmailVisible': instance.isEmailVisible,
      'location': instance.location,
      'author': instance.author,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ReportAuthorImpl _$$ReportAuthorImplFromJson(Map<String, dynamic> json) =>
    _$ReportAuthorImpl(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$ReportAuthorImplToJson(_$ReportAuthorImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
    };

_$ReportImageImpl _$$ReportImageImplFromJson(Map<String, dynamic> json) =>
    _$ReportImageImpl(
      publicId: json['public_id'] as String,
      secureUrl: json['secure_url'] as String,
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$$ReportImageImplToJson(_$ReportImageImpl instance) =>
    <String, dynamic>{
      'public_id': instance.publicId,
      'secure_url': instance.secureUrl,
      '_id': instance.id,
    };

_$ReportLocationImpl _$$ReportLocationImplFromJson(Map<String, dynamic> json) =>
    _$ReportLocationImpl(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      address: json['address'] as String,
    );

Map<String, dynamic> _$$ReportLocationImplToJson(
  _$ReportLocationImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'coordinates': instance.coordinates,
  'address': instance.address,
};
