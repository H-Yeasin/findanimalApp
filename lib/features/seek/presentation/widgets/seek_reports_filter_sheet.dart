import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/seek_report_filters_provider.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class SeekReportsFilterSheet extends ConsumerStatefulWidget {
  const SeekReportsFilterSheet({this.initialSection = 'all', super.key});

  final String initialSection;

  @override
  ConsumerState<SeekReportsFilterSheet> createState() =>
      _SeekReportsFilterSheetState();
}

class _SeekReportsFilterSheetState
    extends ConsumerState<SeekReportsFilterSheet> {
  late TextEditingController _searchController;
  late double _radius;
  late List<String> _statuses;
  late String _sortBy;
  late String _sort;

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(seekReportFiltersProvider);
    _searchController = TextEditingController(
      text: currentFilters['search'] ?? '',
    );
    _radius = (currentFilters['radius'] as num?)?.toDouble() ?? 5.0;

    final statusData = currentFilters['status'];
    if (statusData is List) {
      _statuses = List<String>.from(statusData);
    } else if (statusData == 'all' || statusData == null) {
      _statuses = [];
    } else {
      _statuses = [statusData.toString()];
    }

    _sortBy = currentFilters['sortBy'] ?? 'date';
    _sort = currentFilters['sort'] ?? 'descending';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.body.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: Color(0xFFBA4A22),
          fontFamily: 'EricaOne',
          letterSpacing: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.adjustFilters,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFBA4A22),
                    fontFamily: 'EricaOne',
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFFBA4A22),
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1, color: Color(0xFFF2E6D8)),
            _buildSectionTitle(l10n.searchAnimal),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHintExample,
                hintStyle: AppTextStyles.body.copyWith(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFBA4A22)),
                filled: true,
                fillColor: const Color(0xFFFBF4E9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            _buildSectionTitle(l10n.status),
            Wrap(
              spacing: 10,
              runSpacing: 5,
              children: ['lost', 'found', 'sighted', 'rescued'].map((s) {
                final isSelected = _statuses.contains(s);
                return ChoiceChip(
                  label: Text(_statusLabel(l10n, s).toUpperCase()),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _statuses.add(s);
                      } else {
                        _statuses.remove(s);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFBA4A22),
                  labelStyle: AppTextStyles.body.copyWith(
                    color: isSelected ? Colors.white : const Color(0xFFBA4A22),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: const Color(0xFFBA4A22),
                      width: isSelected ? 0 : 1,
                    ),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            _buildSectionTitle(l10n.searchRadius),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFFBA4A22),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.radiusValue(_radius.toInt()),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Slider(
              value: _radius,
              min: 1,
              max: 50,
              activeColor: const Color(0xFFBA4A22),
              inactiveColor: const Color(0xFFF2E6D8),
              onChanged: (val) {
                setState(() => _radius = val);
              },
            ),
            _buildSectionTitle(l10n.sortBy),
            DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFBF4E9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'date', child: Text(l10n.date)),
                DropdownMenuItem(value: 'name', child: Text(l10n.name)),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _sortBy = val);
              },
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA4A22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: _applyFilters,
                child: Text(
                  l10n.applyFilters,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'EricaOne',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _applyFilters() async {
    final updatedFilters = <String, dynamic>{
      'page': 1,
      'limit': 10,
      'status': _statuses,
      'sortBy': _sortBy,
      'sort': _sort,
    };

    if (_searchController.text.trim().isNotEmpty) {
      updatedFilters['search'] = _searchController.text.trim();
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          final position = await Geolocator.getCurrentPosition();
          updatedFilters['lat'] = position.latitude;
          updatedFilters['lng'] = position.longitude;
          updatedFilters['radius'] = _radius.toInt();
        }
      }
    } catch (_) {
      // Keep global filters when location lookup fails.
    }

    if (!mounted) return;
    ref.read(seekReportFiltersProvider.notifier).state = updatedFilters;
    Navigator.pop(context);
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'lost':
        return l10n.statusMissing;
      case 'found':
        return l10n.statusFound;
      case 'sighted':
        return l10n.filterSightedAnimals;
      case 'rescued':
        return l10n.statusRescued;
      case 'all':
      default:
        return l10n.statusAll;
    }
  }
}
