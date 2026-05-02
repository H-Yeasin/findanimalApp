import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String content,
    required CommentAuthor author,
    required String report,
    CommentImage? image,
    String? parent,
    required List<String> likes,
    required bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<CommentModel> replies,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

class ProfileImageConverter implements JsonConverter<String?, Object?> {
  const ProfileImageConverter();

  @override
  String? fromJson(Object? json) {
    try {
      if (json == null) return null;
      if (json is String) return json;
      if (json is Map) {
        final secureUrl = json['secure_url'];
        if (secureUrl is String) return secureUrl;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('ProfileImageConverter error: $e');
      }
      return null;
    }
  }

  @override
  Object? toJson(String? object) {
    return object;
  }
}

@freezed
class CommentAuthor with _$CommentAuthor {
  const factory CommentAuthor({
    required String id,
    required String firstName,
    required String lastName,
    @ProfileImageConverter() String? profileImage,
  }) = _CommentAuthor;

  factory CommentAuthor.fromJson(Map<String, dynamic> json) =>
      _$CommentAuthorFromJson(json);
}

@freezed
class CommentImage with _$CommentImage {
  const factory CommentImage({
    required String publicId,
    required String secureUrl,
  }) = _CommentImage;

  factory CommentImage.fromJson(Map<String, dynamic> json) =>
      _$CommentImageFromJson(json);
}
