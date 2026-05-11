import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';
import '../providers/missions_filters_provider.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class MissionsFiltersBottomSheet extends ConsumerStatefulWidget {
  const MissionsFiltersBottomSheet({
    this.initialSection = MissionsFilterSection.sort,
    super.key,
  });

  final MissionsFilterSection initialSection;

  @override
  ConsumerState<MissionsFiltersBottomSheet> createState() =>
      _MissionsFiltersBottomSheetState();
}

class _MissionsFiltersBottomSheetState
    extends ConsumerState<MissionsFiltersBottomSheet> {
  static const _radiusOptions = [1, 5, 10, 25, 50];

  late int _radius;
  late String _sort;
  late MissionsFilterSection _activeSection;

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(missionsFiltersProvider);
    _radius = (currentFilters['radius'] as num?)?.toInt() ?? 50;
    _sort = currentFilters['sort']?.toString() ?? 'descending';
    _activeSection = widget.initialSection;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 18,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: PartnerPageTitle(
                    _activeSection == MissionsFilterSection.sort
                        ? l10n.sortBy
                        : l10n.searchRadius,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: PartnerUiColors.brand,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24, color: PartnerUiColors.brand),
            Row(
              children: [
                Expanded(
                  child: _TopToggleButton(
                    label: l10n.sortBy,
                    isSelected: _activeSection == MissionsFilterSection.sort,
                    onTap: () {
                      setState(
                        () => _activeSection = MissionsFilterSection.sort,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TopToggleButton(
                    label: l10n.searchRadius,
                    isSelected: _activeSection == MissionsFilterSection.radius,
                    onTap: () {
                      setState(
                        () => _activeSection = MissionsFilterSection.radius,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _activeSection == MissionsFilterSection.sort
                  ? _SortSection(
                      key: const ValueKey('sort'),
                      currentSort: _sort,
                      onChanged: (value) => setState(() => _sort = value),
                    )
                  : _RadiusSection(
                      key: const ValueKey('radius'),
                      currentRadius: _radius,
                      options: _radiusOptions,
                      onChanged: (value) => setState(() => _radius = value),
                    ),
            ),
            const SizedBox(height: 24),
            Center(
              child: PartnerPublishButton(
                label: l10n.applyFilters.toUpperCase(),
                onTap: _applyFilters,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilters() {
    final currentFilters = ref.read(missionsFiltersProvider);
    ref.read(missionsFiltersProvider.notifier).state = {
      ...currentFilters,
      'page': 1,
      'limit': 10,
      'sortBy': 'date',
      'sort': _sort,
      'radius': _radius,
    };

    Navigator.pop(context);
  }
}

enum MissionsFilterSection { sort, radius }

class _TopToggleButton extends StatelessWidget {
  const _TopToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? PartnerUiColors.brand : PartnerUiColors.panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PartnerUiColors.brand),
        ),
        alignment: Alignment.center,
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.condensedSectionTitle.copyWith(
            fontSize: 14,
            color: isSelected ? Colors.white : PartnerUiColors.brand,
          ),
        ),
      ),
    );
  }
}

class _SortSection extends StatelessWidget {
  const _SortSection({
    required this.currentSort,
    required this.onChanged,
    super.key,
  });

  final String currentSort;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _OptionTile(
          label: l10n.sortByNewest,
          selected: currentSort == 'descending',
          onTap: () => onChanged('descending'),
        ),
        const SizedBox(height: 10),
        _OptionTile(
          label: l10n.sortByOldest,
          selected: currentSort == 'ascending',
          onTap: () => onChanged('ascending'),
        ),
      ],
    );
  }
}

class _RadiusSection extends StatelessWidget {
  const _RadiusSection({
    required this.currentRadius,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final int currentRadius;
  final List<int> options;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((radius) {
        final isSelected = currentRadius == radius;
        return ChoiceChip(
          label: Text('$radius km'),
          selected: isSelected,
          onSelected: (_) => onChanged(radius),
          selectedColor: PartnerUiColors.brand,
          backgroundColor: PartnerUiColors.panel,
          labelStyle: AppTextStyles.condensedSectionTitle.copyWith(
            fontSize: 12,
            color: isSelected ? Colors.white : PartnerUiColors.brand,
          ),
          side: const BorderSide(color: PartnerUiColors.brand),
          showCheckmark: false,
        );
      }).toList(),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: PartnerUiColors.panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PartnerUiColors.brand),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.condensedSectionTitle.copyWith(
                  fontSize: 12,
                  color: PartnerUiColors.brand,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: PartnerUiColors.brand,
            ),
          ],
        ),
      ),
    );
  }
}
