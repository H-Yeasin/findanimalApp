import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/contact_providers.dart';
import 'data/models/contact_model.dart';
import 'presentation/details_shelter_veterinarians.dart';
import '../../core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';

class SheltersScreen extends ConsumerStatefulWidget {
  const SheltersScreen({super.key});

  @override
  ConsumerState<SheltersScreen> createState() => _SheltersScreenState();
}

class _SheltersScreenState extends ConsumerState<SheltersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brandPrimary = Color(0xFFBA4A22);
    final surface = Color(0xFFFBF4E9);
    final cardBg = Color(0xFFFFF6E5);

    final sheltersAsync = ref.watch(sheltersProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: surface,
      body: AppBackground(
        showGridFromTop: true,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.read(sheltersProvider.notifier).fetchContacts(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                // Header
                AppTopBar(title: l10n.listShelters),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    l10n.sheltersBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: brandPrimary,
                      fontWeight: FontWeight.bold,
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
                            style: TextStyle(
                              color: brandPrimary,
                              fontWeight: FontWeight.bold,
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
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: brandPrimary,
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
                  loading: () => Center(
                    child: CircularProgressIndicator(color: brandPrimary),
                  ),
                  error: (err, stack) => Center(
                    child: Text(
                      l10n.unknownError,
                      style: TextStyle(color: brandPrimary),
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) {
          ref.read(sheltersProvider.notifier).setSearchQuery(value);
        },
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: color),
          hintText: l10n.searchByName,
          hintStyle: TextStyle(color: color.withValues(alpha: 0.5)),
          border: InputBorder.none,
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(sheltersProvider.notifier).setSearchQuery('');
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.filterBySortBy,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.keyboard_arrow_down, color: color),
        ],
      ),
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
    final imageUrl =
        shelter.fullImageUrl ??
        'https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?q=80&w=100';
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
            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: color.withValues(alpha: 0.1),
                child: Icon(Icons.business, color: color),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                Text(
                  address,
                  style: TextStyle(
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
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}
