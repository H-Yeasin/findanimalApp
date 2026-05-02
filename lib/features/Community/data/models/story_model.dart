import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
class StoryModel with _$StoryModel {
  const factory StoryModel({
    required String id,
    required StoryUser user,
    required StoryMedia media,
    String? caption,
    required StoryLocation location,
    required int viewsCount,
    required DateTime expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}

@freezed
class StoryUser with _$StoryUser {
  const factory StoryUser({
    required String id,
    required String firstName,
    required String lastName,
    StoryProfileImage? profileImage,
  }) = _StoryUser;

  factory StoryUser.fromJson(Map<String, dynamic> json) =>
      _$StoryUserFromJson(json);
}

@freezed
class StoryProfileImage with _$StoryProfileImage {
  const factory StoryProfileImage({
    required String publicId,
    required String secureUrl,
  }) = _StoryProfileImage;

  factory StoryProfileImage.fromJson(Map<String, dynamic> json) =>
      _$StoryProfileImageFromJson(json);
}

@freezed
class StoryMedia with _$StoryMedia {
  const factory StoryMedia({
    required String url,
    required String publicId,
    required String type,
  }) = _StoryMedia;

  factory StoryMedia.fromJson(Map<String, dynamic> json) =>
      _$StoryMediaFromJson(json);
}

@freezed
class StoryLocation with _$StoryLocation {
  const factory StoryLocation({
    required String type,
    required List<double> coordinates,
    String? address,
  }) = _StoryLocation;

  factory StoryLocation.fromJson(Map<String, dynamic> json) =>
      _$StoryLocationFromJson(json);
}
