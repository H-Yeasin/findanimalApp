import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import 'scroll_appearance_wrapper.dart';

class FAQSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Color brandPrimary;
  final Color cardBg;
  final AppLocalizations l10n;

  const FAQSearchBar({
    super.key,
    required this.controller,
    required this.brandPrimary,
    required this.cardBg,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollAppearanceWrapper(
      type: AnimationType.fade,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: brandPrimary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFFBA4A22), size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: l10n.searchTopic,
                  hintStyle: const TextStyle(
                    color: Color(0x80BA4A22),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
