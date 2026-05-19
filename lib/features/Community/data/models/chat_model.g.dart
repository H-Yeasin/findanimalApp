// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['_id'] as String? ?? json['id'] as String,
      user: ChatUser.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => ChatMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] == null
          ? null
          : ChatLocation.fromJson(json['location'] as Map<String, dynamic>),
      likesCount: (json['likesCount'] as num?)?.toInt(),
      commentsCount: (json['commentsCount'] as num?)?.toInt(),
      replyTo: json['replyTo'] == null
          ? null
          : ChatModel.fromJson(json['replyTo'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'content': instance.content,
      'media': instance.media,
      'location': instance.location,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'replyTo': instance.replyTo,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ChatUserImpl _$$ChatUserImplFromJson(Map<String, dynamic> json) =>
    _$ChatUserImpl(
      id: json['_id'] as String? ?? json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImage: json['profileImage'] == null
          ? null
          : ChatProfileImage.fromJson(
              json['profileImage'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$ChatUserImplToJson(_$ChatUserImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profileImage': instance.profileImage,
    };

_$ChatProfileImageImpl _$$ChatProfileImageImplFromJson(
  Map<String, dynamic> json,
) => _$ChatProfileImageImpl(
  publicId: json['public_id'] as String? ?? json['publicId'] as String,
  secureUrl: json['secure_url'] as String? ?? json['secureUrl'] as String,
);

Map<String, dynamic> _$$ChatProfileImageImplToJson(
  _$ChatProfileImageImpl instance,
) => <String, dynamic>{
  'public_id': instance.publicId,
  'secure_url': instance.secureUrl,
};

_$ChatMediaImpl _$$ChatMediaImplFromJson(Map<String, dynamic> json) =>
    _$ChatMediaImpl(
      url: json['url'] as String,
      publicId: json['public_id'] as String? ?? json['publicId'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$ChatMediaImplToJson(_$ChatMediaImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'public_id': instance.publicId,
      'type': instance.type,
    };

_$ChatLocationImpl _$$ChatLocationImplFromJson(Map<String, dynamic> json) =>
    _$ChatLocationImpl(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$ChatLocationImplToJson(_$ChatLocationImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
      'address': instance.address,
    };
