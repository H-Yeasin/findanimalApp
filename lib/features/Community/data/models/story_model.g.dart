// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryModelImpl _$$StoryModelImplFromJson(Map<String, dynamic> json) =>
    _$StoryModelImpl(
      id: json['_id'] as String,
      user: StoryUser.fromJson(json['user'] as Map<String, dynamic>),
      media: StoryMedia.fromJson(json['media'] as Map<String, dynamic>),
      caption: json['caption'] as String?,
      location: StoryLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      viewsCount: (json['viewsCount'] as num).toInt(),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$StoryModelImplToJson(_$StoryModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'media': instance.media,
      'caption': instance.caption,
      'location': instance.location,
      'viewsCount': instance.viewsCount,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$StoryUserImpl _$$StoryUserImplFromJson(Map<String, dynamic> json) =>
    _$StoryUserImpl(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImage: json['profileImage'] == null
          ? null
          : StoryProfileImage.fromJson(
              json['profileImage'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$StoryUserImplToJson(_$StoryUserImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profileImage': instance.profileImage,
    };

_$StoryProfileImageImpl _$$StoryProfileImageImplFromJson(
  Map<String, dynamic> json,
) => _$StoryProfileImageImpl(
  publicId: json['public_id'] as String,
  secureUrl: json['secure_url'] as String,
);

Map<String, dynamic> _$$StoryProfileImageImplToJson(
  _$StoryProfileImageImpl instance,
) => <String, dynamic>{
  'public_id': instance.publicId,
  'secure_url': instance.secureUrl,
};

_$StoryMediaImpl _$$StoryMediaImplFromJson(Map<String, dynamic> json) =>
    _$StoryMediaImpl(
      url: json['url'] as String,
      publicId: json['publicId'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$StoryMediaImplToJson(_$StoryMediaImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'publicId': instance.publicId,
      'type': instance.type,
    };

_$StoryLocationImpl _$$StoryLocationImplFromJson(Map<String, dynamic> json) =>
    _$StoryLocationImpl(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$StoryLocationImplToJson(_$StoryLocationImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
      'address': instance.address,
    };
