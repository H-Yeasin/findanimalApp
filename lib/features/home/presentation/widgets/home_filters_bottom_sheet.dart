import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/localization/app_localizations.dart';
import '../providers/home_providers.dart';

class HomeFiltersBottomSheet extends ConsumerStatefulWidget {
  const HomeFiltersBottomSheet({super.key});

  @override
  ConsumerState<HomeFiltersBottomSheet> createState() =>
      _HomeFiltersBottomSheetState();
}

class _HomeFiltersBottomSheetState
    extends ConsumerState<HomeFiltersBottomSheet> {
  late final TextEditingController _searchController;
  late double _radius;
  late String _status;

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(homeReportFiltersProvider);
    _searchController = TextEditingController(
      text: currentFilters['search'] ?? '',
    );
    _radius = (currentFilters['radius'] as num?)?.toDouble() ?? 5.0;
    _status = currentFilters['status'] ?? 'all';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.homeFilterTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBA4A22),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFFBA4A22)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: l10n.homeSearchExample,
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFBA4A22)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.status,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFBA4A22),
            ),
          ),
          DropdownButton<String>(
            value: _status,
            isExpanded: true,
            items: [
              DropdownMenuItem(value: 'all', child: Text(l10n.statusAll)),
              DropdownMenuItem(
                value: 'missing',
                child: Text(l10n.statusMissing),
              ),
              DropdownMenuItem(value: 'found', child: Text(l10n.statusFound)),
              DropdownMenuItem(
                value: 'rescued',
                child: Text(l10n.statusRescued),
              ),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _status = val);
            },
          ),
          const SizedBox(height: 20),
          Text(
            l10n.radiusValue(_radius.toInt()),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFBA4A22),
            ),
          ),
          Slider(
            value: _radius,
            min: 1,
            max: 50,
            activeColor: const Color(0xFFBA4A22),
            onChanged: (val) {
              setState(() => _radius = val);
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA4A22),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _applyFilters,
              child: Text(
                l10n.applyFilters,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _applyFilters() async {
    final currentFilters = ref.read(homeReportFiltersProvider);
    final updatedFilters = Map<String, dynamic>.from(currentFilters);

    if (_searchController.text.trim().isNotEmpty) {
      updatedFilters['search'] = _searchController.text.trim();
    } else {
      updatedFilters.remove('search');
    }

    updatedFilters['status'] = _status;

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
          updatedFilters.remove('sortBy');
          updatedFilters.remove('sort');
        }
      }
    } catch (e) {
      updatedFilters.remove('lat');
      updatedFilters.remove('lng');
      updatedFilters.remove('radius');
    }

    updatedFilters['page'] = 1;

    if (!mounted) return;
    ref.read(homeReportFiltersProvider.notifier).state = updatedFilters;
    Navigator.pop(context);
  }
}
