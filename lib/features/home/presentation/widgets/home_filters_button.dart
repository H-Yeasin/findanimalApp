import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

class HomeFiltersButton extends StatelessWidget {
  const HomeFiltersButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFEFE1D1), width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.filters,
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 100),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFFBA4A22)),
            ],
          ),
        ),
      ),
    );
  }
}
