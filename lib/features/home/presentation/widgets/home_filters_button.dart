import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/home_providers.dart';

/// Inline expandable filters for the Home feed – mirrors the Seek section
/// pattern with status checkboxes, sort radio buttons, and radius selection.
class HomeInlineFilters extends ConsumerStatefulWidget {
  const HomeInlineFilters({super.key});

  @override
  ConsumerState<HomeInlineFilters> createState() => _HomeInlineFiltersState();
}

class _HomeInlineFiltersState extends ConsumerState<HomeInlineFilters> {
  static const double _collapsedFilterHeight = 55;

  bool _filtersExpanded = false;
  bool _sortExpanded = false;
  bool _radiusExpanded = false;

  // ───────────────────────── build ─────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = ref.watch(homeReportFiltersProvider);
    final statusList = (filters['status'] is List)
        ? List<String>.from(filters['status'])
        : (filters['status'] == 'all'
            ? <String>[]
            : [filters['status'].toString()]);
    final sort = (filters['sort'] ?? 'descending').toString();
    final radius = (filters['radius'] as num?)?.toInt() ?? 5;
    final hasLocation = filters.containsKey('lat');

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Status filter card ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _buildStatusFilter(l10n, statusList),
          ),
          const SizedBox(height: 8),
          // ── Sort & Radius pills ──
          _buildSortAndRadiusControls(
            l10n: l10n,
            sort: sort,
            radius: radius,
            hasLocation: hasLocation,
          ),
        ],
      ),
    );
  }

  // ─────────────────── Status filter ───────────────────────
  Widget _buildStatusFilter(AppLocalizations l10n, List<String> currentStatuses) {
    final options = _statusFilterOptions(l10n);

    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: _collapsedFilterHeight),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_filtersExpanded ? 18 : 25),
          border: Border.all(color: const Color(0xFFF2E6D8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _filtersExpanded = !_filtersExpanded;
                });
              },
              borderRadius: BorderRadius.circular(35),
              child: SizedBox(
                height: _collapsedFilterHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.filters,
                      style: const TextStyle(
                        color: Color(0xFFBA4A22),
                        fontSize: 15,
                        fontFamily: 'EricaOne',
                      ),
                    ),
                    Icon(
                      _filtersExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFFBA4A22),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            if (_filtersExpanded) ...[
              const Divider(height: 1, color: Color(0xFFF2E6D8)),
              const SizedBox(height: 10),
              ...options.map((option) {
                final isSelected = currentStatuses.contains(option.value);
                return _FilterOptionRow(
                  label: option.label,
                  isSelected: isSelected,
                  onTap: () => _toggleStatus(option.value, currentStatuses),
                );
              }),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  // ───────────── Sort & Radius pills + menus ───────────────
  Widget _buildSortAndRadiusControls({
    required AppLocalizations l10n,
    required String sort,
    required int radius,
    required bool hasLocation,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _sortExpanded = !_sortExpanded;
                      _radiusExpanded = false;
                    });
                  },
                  child: _FilterPill(
                    label: _sortLabel(l10n, sort).toUpperCase(),
                    icon: _sortExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _radiusExpanded = !_radiusExpanded;
                      _sortExpanded = false;
                    });
                  },
                  child: _FilterPill(
                    label: hasLocation
                        ? l10n.nearbyKm(radius)
                        : l10n.globalSearch,
                    icon: _radiusExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _sortExpanded
                ? _buildSortMenu(l10n, sort)
                : _radiusExpanded
                    ? _buildRadiusMenu(radius)
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSortMenu(AppLocalizations l10n, String currentSort) {
    return _FilterPanel(
      topPadding: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RadioOptionRow<String>(
            value: 'descending',
            groupValue: currentSort,
            label: l10n.sortByNewest,
            onChanged: _setDateSort,
          ),
          _RadioOptionRow<String>(
            value: 'ascending',
            groupValue: currentSort,
            label: l10n.sortByOldest,
            onChanged: _setDateSort,
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusMenu(int currentRadius) {
    const radiusOptions = [1, 5, 10, 25, 50];

    return _FilterPanel(
      topPadding: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: radiusOptions.map((radius) {
          return _RadioOptionRow<int>(
            value: radius,
            groupValue: currentRadius,
            label: '$radius km',
            onChanged: _setRadius,
          );
        }).toList(),
      ),
    );
  }

  // ───────────────── provider helpers ──────────────────────
  List<_StatusFilterOption> _statusFilterOptions(AppLocalizations l10n) {
    return [
      _StatusFilterOption('lost', l10n.filterLostAnimals),
      _StatusFilterOption('found', l10n.filterFoundAnimals),
      _StatusFilterOption('sighted', l10n.filterSightedAnimals),
      _StatusFilterOption('rescued', l10n.filterInjuredAnimals),
    ];
  }

  void _toggleStatus(String status, List<String> currentStatuses) {
    final currentFilters = ref.read(homeReportFiltersProvider);
    final nextStatuses = List<String>.from(currentStatuses);

    if (nextStatuses.contains(status)) {
      nextStatuses.remove(status);
    } else {
      nextStatuses.add(status);
    }

    ref.read(homeReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'status': nextStatuses,
      'page': 1,
    };
  }

  void _setDateSort(String sort) {
    final currentFilters = ref.read(homeReportFiltersProvider);
    ref.read(homeReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'sortBy': 'date',
      'sort': sort,
      'page': 1,
    };
    setState(() {
      _sortExpanded = false;
    });
  }

  void _setRadius(int radius) {
    final currentFilters = ref.read(homeReportFiltersProvider);
    ref.read(homeReportFiltersProvider.notifier).state = {
      ...currentFilters,
      'radius': radius,
      'page': 1,
    };
    setState(() {
      _radiusExpanded = false;
    });
  }

  String _sortLabel(AppLocalizations l10n, String sort) {
    return sort == 'ascending' ? l10n.sortByOldest : l10n.sortByNewest;
  }
}

// ═══════════════════════════════════════════════════════════
//  Private helper widgets
// ═══════════════════════════════════════════════════════════

class _StatusFilterOption {
  const _StatusFilterOption(this.value, this.label);

  final String value;
  final String label;
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFBA4A22),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(icon, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({required this.child, this.topPadding = 0});

  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF2E6D8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _RadioOptionRow<T> extends StatelessWidget {
  const _RadioOptionRow({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 34,
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: (next) {
                if (next != null) onChanged(next);
              },
              activeColor: const Color(0xFFBA4A22),
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontSize: 15,
                  fontFamily: 'EricaOne',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterOptionRow extends StatelessWidget {
  const _FilterOptionRow({
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
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 28,
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFBA4A22) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
              ),
              child: Icon(
                isSelected ? Icons.check_rounded : Icons.close_rounded,
                color: isSelected ? Colors.white : const Color(0xFFBA4A22),
                size: 13,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontSize: 12,
                  fontFamily: 'EricaOne',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
