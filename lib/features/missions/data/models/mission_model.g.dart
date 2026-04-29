// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MissionModelImpl _$$MissionModelImplFromJson(Map<String, dynamic> json) =>
    _$MissionModelImpl(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      duration: json['duration'] as String,
      points: (json['points'] as num?)?.toInt(),
      photo: json['photo'] == null
          ? null
          : MissionPhoto.fromJson(json['photo'] as Map<String, dynamic>),
      status: json['status'] as String,
      partner: json['partner'] == null
          ? null
          : MissionPartner.fromJson(json['partner'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MissionModelImplToJson(_$MissionModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'address': instance.address,
      'duration': instance.duration,
      'points': instance.points,
      'photo': instance.photo,
      'status': instance.status,
      'partner': instance.partner,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$MissionPhotoImpl _$$MissionPhotoImplFromJson(Map<String, dynamic> json) =>
    _$MissionPhotoImpl(
      publicId: json['public_id'] as String,
      secureUrl: json['secure_url'] as String,
    );

Map<String, dynamic> _$$MissionPhotoImplToJson(_$MissionPhotoImpl instance) =>
    <String, dynamic>{
      'public_id': instance.publicId,
      'secure_url': instance.secureUrl,
    };

_$MissionPartnerImpl _$$MissionPartnerImplFromJson(Map<String, dynamic> json) =>
    _$MissionPartnerImpl(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      company: json['company'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$MissionPartnerImplToJson(
  _$MissionPartnerImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'company': instance.company,
  'email': instance.email,
};
