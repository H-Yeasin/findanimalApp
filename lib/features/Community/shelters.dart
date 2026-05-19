import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'presentation/providers/contact_providers.dart';
import 'presentation/widgets/contact_filter_panel.dart';
import 'data/models/contact_model.dart';
import 'presentation/details_shelter_veterinarians.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';

class SheltersScreen extends ConsumerStatefulWidget {
  const SheltersScreen({super.key});

  @override
  ConsumerState<SheltersScreen> createState() => _SheltersScreenState();
}

class _SheltersScreenState extends ConsumerState<SheltersScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFilterExpanded = false;
  bool _filterByDepartment = false;
  bool _filterByRegion = false;
  String _sortSelection = 'alpha_az';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFFBA4A22);
    const surface = Color(0xFFFBF4E9);
    const cardBg = Color(0xFFFFF6E5);

    final sheltersAsync = ref.watch(sheltersProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: surface,
      body: AppBackground(
        showGridFromTop: true,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(sheltersProvider.notifier).fetchContacts(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Header
                  const SizedBox(height: 10),
                  AppTopBar(title: l10n.listShelters),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.sheltersBody,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Updated Image
                  Image.asset(
                    AppAssets.shelterHeader,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  _buildSearchBar(cardBg, brandPrimary, l10n),
                  const SizedBox(height: 10),

                  // Filter Dropdown
                  _buildFilterDropdown(cardBg, brandPrimary, l10n),
                  const SizedBox(height: 30),

                  // List Section
                  sheltersAsync.when(
                    data: (shelters) {
                      if (shelters.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              l10n.noReportsFound,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.brandPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                l10n.allShelters.toUpperCase(),
                                style: AppTextStyles.heading.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: shelters.length,
                            itemBuilder: (context, index) {
                              final shelter = shelters[index];
                              return _buildShelterCard(
                                shelter,
                                cardBg,
                                brandPrimary,
                                l10n,
                              );
                            },
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: brandPrimary),
                    ),
                    error: (err, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          l10n.errorLoadingFailed,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: brandPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(Color cardBg, Color color, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        onSubmitted: (value) {
          ref.read(sheltersProvider.notifier).setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: l10n.searchByName,
          hintStyle: AppTextStyles.caption.copyWith(
            color: color.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: color),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(sheltersProvider.notifier).setSearchQuery('');
                    setState(() {});
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(
    Color cardBg,
    Color color,
    AppLocalizations l10n,
  ) {
    return ContactFilterPanel(
      cardBg: cardBg,
      color: color,
      l10n: l10n,
      isExpanded: _isFilterExpanded,
      filterByDepartment: _filterByDepartment,
      filterByRegion: _filterByRegion,
      sortSelection: _sortSelection,
      onToggleExpanded: () {
        setState(() {
          _isFilterExpanded = !_isFilterExpanded;
        });
      },
      onDepartmentChanged: (value) {
        setState(() {
          _filterByDepartment = value;
        });
      },
      onRegionChanged: (value) {
        setState(() {
          _filterByRegion = value;
        });
      },
      onSortChanged: (value) {
        setState(() {
          _sortSelection = value;
        });
      },
    );
  }

  Widget _buildShelterCard(
    ContactModel shelter,
    Color cardBg,
    Color color,
    AppLocalizations l10n,
  ) {
    final name = shelter.name;
    final address = shelter.fullAddress;
    final imageUrl = shelter.fullImageUrl;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _shelterFallback(color),
                  )
                : _shelterFallback(color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.subtitle.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                Text(
                  address,
                  style: AppTextStyles.caption.copyWith(
                    color: color.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildSmallButton(
                      l10n.seeOnMap.toUpperCase(),
                      Colors.white,
                      color,
                      color,
                    ),
                    const SizedBox(width: 10),
                    _buildSmallButton(
                      l10n.seeDetails.toUpperCase(),
                      color,
                      Colors.white,
                      color,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsShelterVeterinariansScreen(
                                  contact: shelter,
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(
    String label,
    Color bgColor,
    Color textColor,
    Color borderColor, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 8,
          ),
        ),
      ),
    );
  }

  Widget _shelterFallback(Color color) {
    return Image.asset(
      AppAssets.shelterHeader,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 60,
        height: 60,
        color: color.withValues(alpha: 0.1),
        child: Icon(Icons.business, color: color),
      ),
    );
  }
}
