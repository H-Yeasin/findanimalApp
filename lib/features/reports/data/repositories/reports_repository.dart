import 'dart:convert';
import 'package:dio/dio.dart';
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
    final response = await _apiClient.get(ApiEndpoints.getMyReports);
    final List<dynamic> data = response.data['data'];
    return data.map((json) => ReportModel.fromJson(json)).toList();
  }

  Future<void> createReport(ReportFormState state) async {
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
      'isPhoneVisible': state.isPhoneVisible,
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

    await _apiClient.post(ApiEndpoints.createReport, data: formData);
  }

  Future<void> updateReport(String id, ReportFormState state) async {
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
      'isPhoneVisible': state.isPhoneVisible,
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

    await _apiClient.patch(ApiEndpoints.updateReport(id), data: formData);
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
