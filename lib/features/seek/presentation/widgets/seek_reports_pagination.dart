import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../providers/seek_reports_provider.dart';

class SeekReportsPagination extends ConsumerWidget {
  const SeekReportsPagination({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(seekReportsProvider);

    return reportsAsync.maybeWhen(
      data: (paginatedData) {
        final currentPage = paginatedData.page;
        final totalPages = paginatedData.totalPages;

        if (totalPages <= 1) return const SizedBox.shrink();

        final pageNodes = <Widget>[];
        var startPage = (currentPage - 1).clamp(1, totalPages).toInt();
        if (startPage + 2 > totalPages) {
          startPage = (totalPages - 2).clamp(1, totalPages).toInt();
        }
        final endPage = (startPage + 2).clamp(1, totalPages).toInt();

        for (var i = startPage; i <= endPage; i++) {
          pageNodes.add(
            SeekPageNumber(
              number: i.toString(),
              isActive: i == currentPage,
              onTap: () {
                if (i != currentPage) {
                  ref.read(seekReportsProvider.notifier).goToPage(i);
                }
              },
            ),
          );
          if (i < endPage) {
            pageNodes.add(const SizedBox(width: 20));
          }
        }

        return Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: currentPage > 1
                    ? () => ref
                          .read(seekReportsProvider.notifier)
                          .goToPage(currentPage - 1)
                    : null,
                child: Icon(
                  Icons.chevron_left,
                  color: currentPage > 1
                      ? const Color(0xFFBA4A22)
                      : Colors.grey,
                  size: 34,
                ),
              ),
              const SizedBox(width: 10),
              ...pageNodes,
              const SizedBox(width: 10),
              GestureDetector(
                onTap: currentPage < totalPages
                    ? () => ref
                          .read(seekReportsProvider.notifier)
                          .goToPage(currentPage + 1)
                    : null,
                child: Icon(
                  Icons.chevron_right,
                  color: currentPage < totalPages
                      ? const Color(0xFFBA4A22)
                      : Colors.grey,
                  size: 34,
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class SeekPageNumber extends StatelessWidget {
  const SeekPageNumber({
    required this.number,
    this.isActive = false,
    this.onTap,
    super.key,
  });

  final String number;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              number,
              style: AppTextStyles.body.copyWith(
                color: const Color(0xFFBA4A22),
                fontSize: 28,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                height: 1,
              ),
            ),
            if (isActive)
              Container(
                width: 20,
                height: 2.5,
                color: const Color(0xFFBA4A22),
                margin: const EdgeInsets.only(top: 2),
              ),
          ],
        ),
      ),
    );
  }
}
