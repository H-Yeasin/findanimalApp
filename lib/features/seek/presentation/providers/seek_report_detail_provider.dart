import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/features/seek/data/models/report_model.dart';
import 'package:hesteka_frontend/features/seek/data/repositories/reports_repository_impl.dart';

final seekReportDetailProvider =
    AsyncNotifierProviderFamily<SeekReportDetailNotifier, ReportModel, String>(
      SeekReportDetailNotifier.new,
    );

class SeekReportDetailNotifier
    extends FamilyAsyncNotifier<ReportModel, String> {
  @override
  Future<ReportModel> build(String id) async {
    final repository = ref.watch(reportsRepositoryProvider);
    return await repository.getReportById(id);
  }
}
