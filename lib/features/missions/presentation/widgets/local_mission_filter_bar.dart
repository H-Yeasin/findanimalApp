import 'package:flutter/material.dart';

import '../../../partner/presentation/widgets/partner_ui_kit.dart';

class LocalMissionFilterBar extends StatelessWidget {
  const LocalMissionFilterBar({
    required this.sortText,
    required this.radiusText,
    required this.onOpenFilters,
    super.key,
  });

  final String sortText;
  final String radiusText;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _FilterButton(text: sortText, onTap: onOpenFilters),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: _FilterButton(text: radiusText, onTap: onOpenFilters),
        ),
      ],
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
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: PartnerUiColors.brand,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'EricaOne',
                  fontSize: 13,
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
