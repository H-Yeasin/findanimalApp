// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      author: CommentAuthor.fromJson(json['author'] as Map<String, dynamic>),
      report: json['report'] as String,
      image: json['image'] == null
          ? null
          : CommentImage.fromJson(json['image'] as Map<String, dynamic>),
      parent: json['parent'] as String?,
      likes: (json['likes'] as List<dynamic>).map((e) => e as String).toList(),
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'author': instance.author,
      'report': instance.report,
      'image': instance.image,
      'parent': instance.parent,
      'likes': instance.likes,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'replies': instance.replies,
    };

_$CommentAuthorImpl _$$CommentAuthorImplFromJson(Map<String, dynamic> json) =>
    _$CommentAuthorImpl(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$$CommentAuthorImplToJson(_$CommentAuthorImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profileImage': instance.profileImage,
    };

_$CommentImageImpl _$$CommentImageImplFromJson(Map<String, dynamic> json) =>
    _$CommentImageImpl(
      publicId: json['public_id'] as String,
      secureUrl: json['secure_url'] as String,
    );

Map<String, dynamic> _$$CommentImageImplToJson(_$CommentImageImpl instance) =>
    <String, dynamic>{
      'public_id': instance.publicId,
      'secure_url': instance.secureUrl,
    };
