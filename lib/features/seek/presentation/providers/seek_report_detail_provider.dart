import 'package:flutter_riverpod/flutter_riverpod.dart';

final seekReportDetailProvider =
    AsyncNotifierProviderFamily<SeekReportDetailNotifier, void, String>(
      SeekReportDetailNotifier.new,
    );

class SeekReportDetailNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {
    return;
  }
}
