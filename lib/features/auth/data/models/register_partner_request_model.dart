import 'package:dio/dio.dart';

class RegisterPartnerRequestModel {
  const RegisterPartnerRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.company,
    this.latitude,
    this.longitude,
    this.locationAddress,
    required this.logoPath,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String company;
  final double? latitude;
  final double? longitude;
  final String? locationAddress;
  final String logoPath;
  final String password;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'company': company,
      'password': password,
    };

    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (locationAddress != null && locationAddress!.trim().isNotEmpty) {
      data['locationAddress'] = locationAddress;
    }

    return data;
  }

  Future<FormData> toFormData() async {
    final fileName = logoPath.split(RegExp(r'[\\/]')).last;
    return FormData.fromMap({
      ...toJson(),
      'logo': await MultipartFile.fromFile(logoPath, filename: fileName),
    });
  }
}
