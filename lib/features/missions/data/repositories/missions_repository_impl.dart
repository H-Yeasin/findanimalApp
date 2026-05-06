import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/network/paginated_response.dart';
import '../../domain/repositories/missions_repository.dart';
import '../models/mission_model.dart';

final missionsRepositoryProvider = Provider<MissionsRepository>((ref) {
  return MissionsRepositoryImpl(ref.watch(apiClientProvider));
});

class MissionsRepositoryImpl implements MissionsRepository {
  const MissionsRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<PaginatedResponse<MissionModel>> getAllMissions({
    Map<String, dynamic>? query,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.getAllLocalMissions,
      queryParameters: query,
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => MissionModel.fromJson(json),
    );
  }

  @override
  Future<List<MissionModel>> getMyMissions() async {
    final response = await _apiClient.get(ApiEndpoints.getMyLocalMissions);
    final payload = response.data as Map<String, dynamic>;
    final items = payload['data'] as List<dynamic>? ?? const [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(MissionModel.fromJson)
        .toList();
  }

  @override
  Future<MissionModel> createLocalMission({
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required String duration,
    required int points,
    MultipartFile? image,
  }) async {
    final data = FormData.fromMap({
      'title': title,
      'description': description,
      'address': address,
      'location': jsonEncode({
        'type': 'Point',
        'coordinates': [longitude, latitude],
      }),
      'duration': duration,
      'points': points,
      ...?(image == null ? null : {'image': image}),
    });

    final response = await _apiClient.post(
      ApiEndpoints.createLocalMission,
      data: data,
    );

    final payload = response.data as Map<String, dynamic>;
    return MissionModel.fromJson(payload['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> joinMission(String missionId) async {
    await _apiClient.post(ApiEndpoints.joinLocalMission(missionId));
  }

  @override
  Future<List<dynamic>> getLocalMissionParticipants(String missionId) async {
    final response = await _apiClient
        .get(ApiEndpoints.getLocalMissionParticipants(missionId));
    final payload = response.data as Map<String, dynamic>;
    return payload['data'] as List<dynamic>? ?? const [];
  }
}
