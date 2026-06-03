import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../seek/data/models/report_model.dart';
import '../../presentation/providers/report_form_provider.dart';

class ReportsRepository {
  const ReportsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ReportModel>> getMyReports() async {
    final response = await _apiClient.get(
      ApiEndpoints.getMyReports,
      options: Options(responseType: ResponseType.plain),
    );
    return compute(parseMyReportsResponse, response.data as String? ?? '');
  }

  Future<void> createReport(ReportFormState state) async {
    final phoneNumber = state.phoneNumber?.trim();
    final emailAddress = state.emailAddress?.trim();
    final Map<String, dynamic> data = {
      'animalName': state.animalName,
      if (state.sourceAnimalId?.isNotEmpty == true)
        'myAnimalId': state.sourceAnimalId,
      'species': ['Dog', 'Cat', 'Bird'].contains(state.species)
          ? state.species
          : 'Other',
      'breed': state.breed,
      'gender': state.gender,
      'age': state.age ?? 'Adult',
      'status': _mapStatus(state.postType),
      'description': state.description,
      'hasMicrochip': _mapYesNoUnknown(state.hasMicrochip),
      'hasTattoo': _mapYesNoUnknown(state.hasTattoo),
      'hasCollarOrHarness': _mapYesNoUnknown(state.hasCollarOrHarness),
      if (phoneNumber != null && phoneNumber.isNotEmpty)
        'contactPhone': phoneNumber,
      'isPhoneVisible': state.isPhoneVisible,
      if (emailAddress != null && emailAddress.isNotEmpty)
        'contactEmail': emailAddress,
      'isEmailVisible': state.isEmailVisible,
      'eventDate': (state.eventDate ?? DateTime.now())
          .toUtc()
          .toIso8601String(),
      'location': jsonEncode({
        'type': 'Point',
        'coordinates': [state.lng ?? 0.0, state.lat ?? 0.0],
        'address': state.address ?? '',
      }),
    };

    final formData = FormData.fromMap(data);

    if (state.images.isNotEmpty) {
      for (final image in state.images) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }
    }

    await _apiClient.post(
      ApiEndpoints.createReport,
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
  }

  Future<void> updateReport(String id, ReportFormState state) async {
    final phoneNumber = state.phoneNumber?.trim();
    final emailAddress = state.emailAddress?.trim();
    final Map<String, dynamic> data = {
      'animalName': state.animalName,
      'species': ['Dog', 'Cat', 'Bird'].contains(state.species)
          ? state.species
          : 'Other',
      'breed': state.breed,
      'gender': state.gender,
      'age': state.age ?? 'Adult',
      'status': _mapStatus(state.postType),
      'description': state.description,
      'hasMicrochip': _mapYesNoUnknown(state.hasMicrochip),
      'hasTattoo': _mapYesNoUnknown(state.hasTattoo),
      'hasCollarOrHarness': _mapYesNoUnknown(state.hasCollarOrHarness),
      if (phoneNumber != null && phoneNumber.isNotEmpty)
        'contactPhone': phoneNumber,
      'isPhoneVisible': state.isPhoneVisible,
      if (emailAddress != null && emailAddress.isNotEmpty)
        'contactEmail': emailAddress,
      'isEmailVisible': state.isEmailVisible,
      'eventDate': (state.eventDate ?? DateTime.now())
          .toUtc()
          .toIso8601String(),
      'location': jsonEncode({
        'type': 'Point',
        'coordinates': [state.lng ?? 0.0, state.lat ?? 0.0],
        'address': state.address ?? '',
      }),
    };

    final formData = FormData.fromMap(data);

    if (state.images.isNotEmpty) {
      for (final image in state.images) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }
    }

    await _apiClient.patch(
      ApiEndpoints.updateReport(id),
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
  }

  String _mapStatus(String? postType) {
    switch (postType?.toLowerCase()) {
      case 'lost':
        return 'lost';
      case 'found':
        return 'found';
      case 'spotted':
        return 'sighted';
      case 'injured':
        return 'rescued';
      default:
        return 'lost';
    }
  }

  String _mapYesNoUnknown(String? value) {
    switch (value) {
      case 'Yes':
        return 'Yes';
      case 'No':
        return 'No';
      default:
        return 'Unknown';
    }
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.watch(apiClientProvider));
});

List<ReportModel> parseMyReportsResponse(String responseBody) {
  final decoded = jsonDecode(responseBody);
  if (decoded is! Map) return [];

  final envelope = Map<String, dynamic>.from(decoded);
  final data = envelope['data'];
  if (data is! List) return [];

  return data
      .whereType<Map>()
      .map((json) => ReportModel.fromJson(Map<String, dynamic>.from(json)))
      .toList();
}
