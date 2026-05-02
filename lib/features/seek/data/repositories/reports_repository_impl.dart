import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paginated_response.dart';
import '../../domain/repositories/reports_repository.dart';
import '../models/report_model.dart';
import '../sources/reports_remote_source.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepositoryImpl(ref.watch(reportsRemoteSourceProvider));
});

class ReportsRepositoryImpl implements ReportsRepository {
  const ReportsRepositoryImpl(this._remoteSource);

  final ReportsRemoteSource _remoteSource;

  @override
  Future<PaginatedResponse<ReportModel>> getAllReports({Map<String, dynamic>? query}) async {
    final cleanedQuery = Map<String, dynamic>.from(query ?? {});
    if (cleanedQuery['status'] == 'all') {
      cleanedQuery.remove('status');
    }
    
    final response = await _remoteSource.getAllReports(query: cleanedQuery);
    
    if (response is! Map<String, dynamic>) {
      return PaginatedResponse(
        data: [],
        total: 0,
        page: 1,
        limit: 10,
        totalPages: 0,
      );
    }

    return PaginatedResponse.fromJson(
      response,
      (json) => ReportModel.fromJson(_sanitizeReportJson(json)),
    );
  }

  Map<String, dynamic> _sanitizeReportJson(Map<String, dynamic> json) {
    return {
      ...json,
      'species': json['species'] ?? 'Unknown',
      'breed': json['breed'] ?? 'Unknown',
      'gender': json['gender'] ?? 'Unknown',
      'age': json['age'] ?? 'Unknown',
      'description': json['description'] ?? '',
      'images': json['images'] ?? [],
      'hasMicrochip': json['hasMicrochip'] ?? 'Unknown',
      'hasTattoo': json['hasTattoo'] ?? 'Unknown',
      'hasCollarOrHarness': json['hasCollarOrHarness'] ?? 'Unknown',
      'eventDate': json['eventDate'] ?? DateTime.now().toIso8601String(),
      'location': json['location'] ?? {
        'type': 'Point',
        'coordinates': [0.0, 0.0],
        'address': '',
      },
    };
  }

  @override
  Future<PaginatedResponse<ReportModel>> getMyReports({Map<String, dynamic>? query}) async {
    final cleanedQuery = Map<String, dynamic>.from(query ?? {});
    if (cleanedQuery['status'] == 'all') {
      cleanedQuery.remove('status');
    }
    cleanedQuery['author'] = 'me';

    final response = await _remoteSource.getAllReports(query: cleanedQuery);
    
    if (response is! Map<String, dynamic>) {
      return PaginatedResponse(
        data: [],
        total: 0,
        page: 1,
        limit: 10,
        totalPages: 0,
      );
    }

    return PaginatedResponse.fromJson(
      response,
      (json) => ReportModel.fromJson(_sanitizeReportJson(json)),
    );
  }

  @override
  Future<ReportModel> getReportById(String id) async {
    final response = await _remoteSource.getReportById(id);
    return ReportModel.fromJson(_sanitizeReportJson(response['data'] as Map<String, dynamic>));
  }
}
