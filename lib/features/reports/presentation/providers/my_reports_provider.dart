import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/reports_repository.dart';
import '../../../seek/data/models/report_model.dart';

final myReportsProvider = FutureProvider.autoDispose<List<ReportModel>>((
  ref,
) async {
  final authStatus = ref.watch(authStateProvider);
  if (authStatus != AuthStatus.authenticated) {
    return const <ReportModel>[];
  }

  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getMyReports();
});
