import 'package:flutter/material.dart';

import '../../../partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class LocalMissionFilterBar extends StatelessWidget {
  const LocalMissionFilterBar({
    required this.sortText,
    required this.radiusText,
    required this.onOpenSort,
    required this.onOpenRadius,
    super.key,
  });

  final String sortText;
  final String radiusText;
  final VoidCallback onOpenSort;
  final VoidCallback onOpenRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stackButtons = constraints.maxWidth < 360;

        if (stackButtons) {
          return Column(
            children: [
              _FilterButton(text: sortText, onTap: onOpenSort),
              const SizedBox(height: 10),
              _FilterButton(text: radiusText, onTap: onOpenRadius),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: _FilterButton(text: sortText, onTap: onOpenSort),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: _FilterButton(text: radiusText, onTap: onOpenRadius),
            ),
          ],
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 42),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: PartnerUiColors.brand,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.condensedSectionTitle.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
