import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class ReportMapCard extends StatelessWidget {
  const ReportMapCard({required this.report, super.key});

  final dynamic report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const cardWidth = 130.0;
    const cardHeight = 78.0;
    final imageUrl = (report.images != null && report.images.isNotEmpty)
        ? report.images.first.secureUrl
        : null;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFBA4A22),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: ClipOval(
                    child: imageUrl != null
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : Container(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        report.animalName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          // fontFamily: 'BrowlCondenced',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      Text(
                        report.breed ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        report.status ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => context.push('/reports/${report.id}'),
            child: Container(
              height: 18,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF4E9),
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Text(
                l10n.viewProfile(
                  report.animalName,
                ), // fallback if seeReport doesn't exist, we'll check it later
                style: AppTextStyles.condensedSectionTitle.copyWith(
                  color: Color(0xFFBA4A22),
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
