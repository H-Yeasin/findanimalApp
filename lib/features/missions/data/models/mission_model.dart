import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_model.freezed.dart';
part 'mission_model.g.dart';

@freezed
class MissionModel with _$MissionModel {
  const factory MissionModel({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String description,
    required String address,
    required String duration,
    int? points,
    MissionPhoto? photo,
    required String status,
    MissionPartner? partner,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MissionModel;

  factory MissionModel.fromJson(Map<String, dynamic> json) =>
      _$MissionModelFromJson(json);
}

@freezed
class MissionPhoto with _$MissionPhoto {
  const factory MissionPhoto({
    @JsonKey(name: 'public_id') required String publicId,
    @JsonKey(name: 'secure_url') required String secureUrl,
  }) = _MissionPhoto;

  factory MissionPhoto.fromJson(Map<String, dynamic> json) =>
      _$MissionPhotoFromJson(json);
}

@freezed
class MissionPartner with _$MissionPartner {
  const factory MissionPartner({
    @JsonKey(name: '_id') required String id,
    required String firstName,
    required String lastName,
    String? company,
    String? email,
    // profileImage if needed
  }) = _MissionPartner;

  factory MissionPartner.fromJson(Map<String, dynamic> json) =>
      _$MissionPartnerFromJson(json);
}
