import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/location_provider.dart';
import '../../../partner/presentation/widgets/partner_ui_kit.dart';
import '../providers/missions_filters_provider.dart';

class MissionsFiltersBottomSheet extends ConsumerStatefulWidget {
  const MissionsFiltersBottomSheet({super.key});

  @override
  ConsumerState<MissionsFiltersBottomSheet> createState() =>
      _MissionsFiltersBottomSheetState();
}

class _MissionsFiltersBottomSheetState
    extends ConsumerState<MissionsFiltersBottomSheet> {
  late TextEditingController _searchController;
  late TextEditingController _companyController;
  late TextEditingController _fromController;
  late TextEditingController _toController;
  late double _radius;
  late String _status;
  late String _sortBy;
  late String _sort;

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(missionsFiltersProvider);
    _searchController = TextEditingController(
      text: currentFilters['search'] ?? '',
    );
    _companyController = TextEditingController(
      text: currentFilters['company'] ?? '',
    );
    _fromController = TextEditingController(text: currentFilters['from'] ?? '');
    _toController = TextEditingController(text: currentFilters['to'] ?? '');
    _radius = (currentFilters['radius'] as num?)?.toDouble() ?? 50.0;
    _status = currentFilters['status'] ?? 'all';
    _sortBy = currentFilters['sortBy'] ?? 'date';
    _sort = currentFilters['sort'] ?? 'descending';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _companyController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        left: 24,
        right: 24,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: PartnerPageTitle(l10n.adjustFilters)),
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
            const Divider(height: 28, color: PartnerUiColors.brand),
            _SectionTitle(l10n.searchMissions),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchByTitle,
                hintStyle: TextStyle(
                  color: PartnerUiColors.brand.withValues(alpha: 0.5),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: PartnerUiColors.brand,
                ),
                filled: true,
                fillColor: PartnerUiColors.panel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: PartnerUiColors.brand),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: PartnerUiColors.brand),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: PartnerUiColors.brand,
                    width: 2,
                  ),
                ),
              ),
            ),
            _SectionTitle(l10n.company),
            _FilterTextField(
              controller: _companyController,
              hintText: l10n.companyNameHint,
              icon: Icons.business_outlined,
            ),
            _SectionTitle(l10n.status),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: ['all', 'active', 'inactive'].map((status) {
                final isSelected = _status == status;
                return ChoiceChip(
                  label: Text(status.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _status = status);
                  },
                  selectedColor: PartnerUiColors.brand,
                  backgroundColor: PartnerUiColors.panel,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : PartnerUiColors.brand,
                    fontFamily: 'EricaOne',
                    fontSize: 12,
                  ),
                  side: const BorderSide(color: PartnerUiColors.brand),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            _SectionTitle('Date range'),
            Row(
              children: [
                Expanded(
                  child: _DateField(controller: _fromController, label: 'From'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DateField(controller: _toController, label: 'To'),
                ),
              ],
            ),
            _SectionTitle(l10n.searchRadius),
            Row(
              children: [
                const Icon(Icons.location_on, color: PartnerUiColors.brand),
                const SizedBox(width: 10),
                Text(
                  l10n.radiusKm.replaceAll(
                    '{radius}',
                    _radius.toInt().toString(),
                  ),
                  style: const TextStyle(
                    color: PartnerUiColors.brand,
                    fontFamily: 'EricaOne',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Slider(
              value: _radius,
              min: 1,
              max: 50,
              activeColor: PartnerUiColors.brand,
              inactiveColor: PartnerUiColors.grid,
              onChanged: (value) => setState(() => _radius = value),
            ),
            _SectionTitle(l10n.sortBy),
            DropdownButtonFormField<String>(
              initialValue: _sortBy,
              decoration: InputDecoration(
                filled: true,
                fillColor: PartnerUiColors.panel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: PartnerUiColors.brand),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: PartnerUiColors.brand),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'date', child: Text(l10n.dateLabel)),
                DropdownMenuItem(value: 'title', child: Text(l10n.titleLabel)),
                DropdownMenuItem(value: 'points', child: Text(l10n.myPoints)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _sortBy = value);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _sort,
              decoration: _dropdownDecoration(),
              items: const [
                DropdownMenuItem(
                  value: 'descending',
                  child: Text('Descending'),
                ),
                DropdownMenuItem(value: 'ascending', child: Text('Ascending')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _sort = value);
              },
            ),
            const SizedBox(height: 28),
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

  Future<void> _applyFilters() async {
    final currentFilters = ref.read(missionsFiltersProvider);
    final updatedFilters = <String, dynamic>{
      ...currentFilters,
      'page': 1,
      'limit': 10,
      'sortBy': _sortBy,
      'sort': _sort,
      'radius': _radius.toInt(),
    };

    if (_status == 'all') {
      updatedFilters.remove('status');
    } else {
      updatedFilters['status'] = _status;
    }

    _putOptionalText(updatedFilters, 'search', _searchController.text);
    _putOptionalText(updatedFilters, 'company', _companyController.text);
    _putOptionalText(updatedFilters, 'from', _fromController.text);
    _putOptionalText(updatedFilters, 'to', _toController.text);

    if (!mounted) return;
    ref.read(missionsFiltersProvider.notifier).state = updatedFilters;
    Navigator.pop(context);
  }

  void _putOptionalText(
    Map<String, dynamic> filters,
    String key,
    String value,
  ) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      filters.remove(key);
    } else {
      filters[key] = trimmed;
    }
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: PartnerUiColors.panel,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: PartnerUiColors.brand),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: PartnerUiColors.brand),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: PartnerFieldLabel(text.toUpperCase()),
    );
  }
}

class _FilterTextField extends StatelessWidget {
  const _FilterTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: PartnerUiColors.brand.withValues(alpha: 0.5),
        ),
        prefixIcon: Icon(icon, color: PartnerUiColors.brand),
        filled: true,
        fillColor: PartnerUiColors.panel,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: PartnerUiColors.brand),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: PartnerUiColors.brand, width: 2),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final initialDate =
            DateTime.tryParse(controller.text) ?? DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (picked == null) return;
        controller.text = picked.toIso8601String().split('T').first;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: PartnerUiColors.brand),
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          color: PartnerUiColors.brand,
        ),
        filled: true,
        fillColor: PartnerUiColors.panel,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: PartnerUiColors.brand),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: PartnerUiColors.brand, width: 2),
        ),
      ),
    );
  }
}
