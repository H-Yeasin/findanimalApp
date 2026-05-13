import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class ContactFilterPanel extends StatelessWidget {
  final Color cardBg;
  final Color color;
  final AppLocalizations l10n;
  final bool isExpanded;
  final bool filterByDepartment;
  final bool filterByRegion;
  final String sortSelection;
  final VoidCallback onToggleExpanded;
  final ValueChanged<bool> onDepartmentChanged;
  final ValueChanged<bool> onRegionChanged;
  final ValueChanged<String> onSortChanged;

  const ContactFilterPanel({
    super.key,
    required this.cardBg,
    required this.color,
    required this.l10n,
    required this.isExpanded,
    required this.filterByDepartment,
    required this.filterByRegion,
    required this.sortSelection,
    required this.onToggleExpanded,
    required this.onDepartmentChanged,
    required this.onRegionChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggleExpanded,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isExpanded ? 'Filtrer par' : l10n.filterBySortBy,
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: color,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 14),
            Container(height: 1, color: color.withValues(alpha: 0.35)),
            const SizedBox(height: 16),
            _FilterOption(
              label: 'Par departement',
              value: filterByDepartment,
              color: color,
              onChanged: onDepartmentChanged,
            ),
            _FilterOption(
              label: 'Par region',
              value: filterByRegion,
              color: color,
              onChanged: onRegionChanged,
            ),
            const SizedBox(height: 18),
            Text(
              l10n.sortBy,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: color.withValues(alpha: 0.35)),
            const SizedBox(height: 16),
            _FilterOption(
              label: 'Alphabetique, de A a Z',
              value: sortSelection == 'alpha_az',
              color: color,
              onChanged: (value) {
                if (value) onSortChanged('alpha_az');
              },
            ),
            _FilterOption(
              label: 'Alphabetique, de Z a A',
              value: sortSelection == 'alpha_za',
              color: color,
              onChanged: (value) {
                if (value) onSortChanged('alpha_za');
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  const _FilterOption({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: Checkbox(
                value: value,
                onChanged: (next) => onChanged(next ?? false),
                activeColor: color,
                checkColor: Colors.white,
                side: BorderSide(color: color.withValues(alpha: 0.8)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
