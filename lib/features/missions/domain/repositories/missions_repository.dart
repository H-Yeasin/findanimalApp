import 'package:dio/dio.dart';
import '../../../../core/network/paginated_response.dart';
import '../../data/models/mission_model.dart';

abstract class MissionsRepository {
  Future<PaginatedResponse<MissionModel>> getAllMissions({
    Map<String, dynamic>? query,
  });
  Future<List<MissionModel>> getMyMissions();
  Future<MissionModel> createLocalMission({
    required String title,
    required String description,
    required String address,
    required String duration,
    required int points,
    MultipartFile? image,
  });
  Future<void> joinMission(String missionId);
  Future<List<dynamic>> getLocalMissionParticipants(String missionId);
}
