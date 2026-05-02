import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    required ChatUser user,
    required String content,
    List<ChatMedia>? media,
    ChatLocation? location,
    int? likesCount,
    int? commentsCount,
    ChatModel? replyTo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}

@freezed
class ChatUser with _$ChatUser {
  const factory ChatUser({
    required String id,
    required String firstName,
    required String lastName,
    ChatProfileImage? profileImage,
  }) = _ChatUser;

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
}

@freezed
class ChatProfileImage with _$ChatProfileImage {
  const factory ChatProfileImage({
    required String publicId,
    required String secureUrl,
  }) = _ChatProfileImage;

  factory ChatProfileImage.fromJson(Map<String, dynamic> json) =>
      _$ChatProfileImageFromJson(json);
}

@freezed
class ChatMedia with _$ChatMedia {
  const factory ChatMedia({
    required String url,
    required String publicId,
    required String type,
  }) = _ChatMedia;

  factory ChatMedia.fromJson(Map<String, dynamic> json) =>
      _$ChatMediaFromJson(json);
}

@freezed
class ChatLocation with _$ChatLocation {
  const factory ChatLocation({
    required String type,
    required List<double> coordinates,
    String? address,
  }) = _ChatLocation;

  factory ChatLocation.fromJson(Map<String, dynamic> json) =>
      _$ChatLocationFromJson(json);
}
