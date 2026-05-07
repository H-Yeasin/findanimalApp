import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/seek_report_detail_provider.dart';
import 'animal_profile_screen.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class SeekReportDetailScreen extends ConsumerWidget {
  const SeekReportDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(seekReportDetailProvider(id));

    return reportAsync.when(
      data: (report) =>
          AnimalProfileScreen(data: AnimalProfileData.fromReport(report)),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text(
            'Could not load report details.',
            style: AppTextStyles.body.copyWith(color: Color(0xFFBA4A22)),
          ),
        ),
      ),
    );
  }
}
