import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../data/models/partner_ad_model.dart';
import '../providers/partner_collection_points_provider.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';

class CollectionPointsScreen extends ConsumerWidget {
  const CollectionPointsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(partnerCollectionPointsProvider);

    return PartnerScreenScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(showBackButton: false),
            const SizedBox(height: 14),
            const PartnerPageTitle('MY\nCOLLECTION POINTS'),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: PartnerUiColors.brand,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final created = await context.push<bool>(
                    RouteNames.partnerCreateCollectionPoint,
                  );
                  if (created == true) {
                    ref.invalidate(partnerCollectionPointsProvider);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('ADD POINT'),
              ),
            ),
            const SizedBox(height: 14),
            pointsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: CircularProgressIndicator(
                    color: PartnerUiColors.brand,
                  ),
                ),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Column(
                  children: [
                    Text(
                      'Could not load your collection points.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: PartnerUiColors.brand,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () =>
                          ref.invalidate(partnerCollectionPointsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (points) {
                if (points.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'No collection points yet.\nCreate your first one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PartnerUiColors.brand,
                        fontFamily: 'EricaOne',
                        fontSize: 20,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: points.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final point = points[index];
                    return _CollectionPointCard(point: point);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionPointCard extends StatelessWidget {
  const _CollectionPointCard({required this.point});

  final PartnerAdModel point;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PartnerUiColors.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PartnerUiColors.brand),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: point.photoUrl != null && point.photoUrl!.isNotEmpty
                ? Image.network(
                    point.photoUrl!,
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, stackTrace) => _placeholderImage(),
                  )
                : _placeholderImage(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point.title,
                  style: const TextStyle(
                    color: PartnerUiColors.brand,
                    fontFamily: 'EricaOne',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  point.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: PartnerUiColors.brand,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  point.status.toUpperCase(),
                  style: const TextStyle(
                    color: PartnerUiColors.brand,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 78,
      height: 78,
      color: const Color(0xFFE4D5B6),
      child: const Icon(
        Icons.location_on_outlined,
        color: PartnerUiColors.brand,
      ),
    );
  }
}
