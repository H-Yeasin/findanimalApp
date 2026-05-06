import 'package:flutter/material.dart';

import '../../../partner/presentation/widgets/partner_ui_kit.dart';

class LocalMissionPagination extends StatelessWidget {
  const LocalMissionPagination({
    required this.page,
    required this.totalPages,
    required this.onPageSelected,
    super.key,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: PartnerUiColors.brand),
            onPressed: page > 1 ? () => onPageSelected(page - 1) : null,
          ),
          for (var i = 1; i <= totalPages; i++)
            _PageNumber(
              number: i,
              active: i == page,
              onTap: i == page ? null : () => onPageSelected(i),
            ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: PartnerUiColors.brand),
            onPressed: page < totalPages
                ? () => onPageSelected(page + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({required this.number, required this.active, this.onTap});

  final int number;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          number.toString(),
          style: TextStyle(
            color: PartnerUiColors.brand,
            fontFamily: 'EricaOne',
            fontSize: 16,
            decoration: active ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }
}
