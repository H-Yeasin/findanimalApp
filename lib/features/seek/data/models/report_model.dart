import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class ReportModel with _$ReportModel {
  const factory ReportModel({
    @JsonKey(name: '_id') required String id,
    required String animalName,
    String? title,
    required String species,
    required String breed,
    required String gender,
    required String age,
    required String status,
    required DateTime eventDate,
    required String description,
    required List<ReportImage> images,
    required String hasMicrochip,
    required String hasTattoo,
    required String hasCollarOrHarness,
    String? contactPhone,
    @Default(false) bool isPhoneVisible,
    String? contactEmail,
    @Default(false) bool isEmailVisible,
    required ReportLocation location,
    ReportAuthor? author,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}

@freezed
class ReportAuthor with _$ReportAuthor {
  const factory ReportAuthor({
    @JsonKey(name: '_id') required String id,
    required String firstName,
    required String lastName,
    String? email,
  }) = _ReportAuthor;

  factory ReportAuthor.fromJson(Map<String, dynamic> json) =>
      _$ReportAuthorFromJson(json);
}

@freezed
class ReportImage with _$ReportImage {
  const factory ReportImage({
    @JsonKey(name: 'public_id') required String publicId,
    @JsonKey(name: 'secure_url') required String secureUrl,
    @JsonKey(name: '_id') String? id,
  }) = _ReportImage;

  factory ReportImage.fromJson(Map<String, dynamic> json) =>
      _$ReportImageFromJson(json);
}

@freezed
class ReportLocation with _$ReportLocation {
  const factory ReportLocation({
    required String type,
    required List<double> coordinates,
    required String address,
  }) = _ReportLocation;

  factory ReportLocation.fromJson(Map<String, dynamic> json) =>
      _$ReportLocationFromJson(json);
}
