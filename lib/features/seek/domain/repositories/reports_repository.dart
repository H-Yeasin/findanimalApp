import '../../../../core/network/paginated_response.dart';
import '../../data/models/report_model.dart';

abstract class ReportsRepository {
  Future<PaginatedResponse<ReportModel>> getAllReports({Map<String, dynamic>? query});
  Future<PaginatedResponse<ReportModel>> getMyReports({Map<String, dynamic>? query});
  Future<ReportModel> getReportById(String id);
}
