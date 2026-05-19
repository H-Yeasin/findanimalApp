import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    @JsonKey(name: '_id') required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address,
    String? city,
    String? postalCode,
    String? country,
    String? company,
    int? pointsBalance,
    String? selfIntroduction,
    String? profession,
    String? role,
    String? status,
    bool? isVerified,
    ProfileImage? profileImage,
    LocationData? location,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

@freezed
class ProfileImage with _$ProfileImage {
  const factory ProfileImage({
    @JsonKey(name: 'public_id') String? public_id,
    @JsonKey(name: 'secure_url') String? secure_url,
  }) = _ProfileImage;

  factory ProfileImage.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageFromJson(json);
}

@freezed
class LocationData with _$LocationData {
  const factory LocationData({
    String? type,
    List<double>? coordinates,
    String? address,
  }) = _LocationData;

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);
}
