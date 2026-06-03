import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    final status = cleanedQuery['status'];
    if (status == 'all' || (status is List && status.isEmpty)) {
      cleanedQuery.remove('status');
    }
    
    final responseBody = await _remoteSource.getAllReports(query: cleanedQuery);
    return compute(parsePaginatedReportsResponse, responseBody);
  }

  @override
  Future<PaginatedResponse<ReportModel>> getMyReports({Map<String, dynamic>? query}) async {
    final cleanedQuery = Map<String, dynamic>.from(query ?? {});
    final status = cleanedQuery['status'];
    if (status == 'all' || (status is List && status.isEmpty)) {
      cleanedQuery.remove('status');
    }
    cleanedQuery['author'] = 'me';

    final responseBody = await _remoteSource.getAllReports(query: cleanedQuery);
    return compute(parsePaginatedReportsResponse, responseBody);
  }

  @override
  Future<ReportModel> getReportById(String id) async {
    final responseBody = await _remoteSource.getReportById(id);
    return compute(parseReportDetailResponse, responseBody);
  }
}

PaginatedResponse<ReportModel> parsePaginatedReportsResponse(
  String responseBody,
) {
  final decoded = jsonDecode(responseBody);
  if (decoded is! Map) {
    return _emptyReportsResponse();
  }

  return PaginatedResponse.fromJson(
    Map<String, dynamic>.from(decoded),
    (json) => ReportModel.fromJson(_sanitizeReportJson(json)),
  );
}

ReportModel parseReportDetailResponse(String responseBody) {
  final decoded = jsonDecode(responseBody);
  if (decoded is! Map) {
    throw const FormatException('Report detail response must be a JSON object.');
  }

  final response = Map<String, dynamic>.from(decoded);
  final data = response['data'];
  if (data is! Map) {
    throw const FormatException('Report detail response is missing data.');
  }

  return ReportModel.fromJson(
    _sanitizeReportJson(Map<String, dynamic>.from(data)),
  );
}

PaginatedResponse<ReportModel> _emptyReportsResponse() {
  return PaginatedResponse(
    data: [],
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 0,
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
    'location':
        json['location'] ??
        {
          'type': 'Point',
          'coordinates': [0.0, 0.0],
          'address': '',
        },
  };
}
