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
    final response = await _remoteSource.getAllReports(query: query);
    
    return PaginatedResponse.fromJson(
      response as Map<String, dynamic>,
      (json) => ReportModel.fromJson(json),
    );
  }

  @override
  Future<PaginatedResponse<ReportModel>> getMyReports({Map<String, dynamic>? query}) async {
    final response = await _remoteSource.getAllReports(query: {
      ...?query,
      'author': 'me', // Example filter for the backend
    });
    
    return PaginatedResponse.fromJson(
      response as Map<String, dynamic>,
      (json) => ReportModel.fromJson(json),
    );
  }

  @override
  Future<ReportModel> getReportById(String id) async {
    final response = await _remoteSource.getReportById(id);
    return ReportModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}
