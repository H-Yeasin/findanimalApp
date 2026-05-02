import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/contact_providers.dart';
import 'data/models/contact_model.dart';
import 'presentation/details_shelter_veterinarians.dart';
import '../../core/localization/app_localizations.dart';

class VeterinariansScreen extends ConsumerStatefulWidget {
  const VeterinariansScreen({super.key});

  @override
  ConsumerState<VeterinariansScreen> createState() =>
      _VeterinariansScreenState();
}

class _VeterinariansScreenState extends ConsumerState<VeterinariansScreen> {
  final TextEditingController _searchController = TextEditingController();

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

    final veterinariansAsync = ref.watch(veterinariansProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(veterinariansProvider.notifier).fetchContacts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: brandPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.undo,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Icon(Icons.person, color: brandPrimary, size: 40),
                    ],
                  ),
                ),

                Text(
                  l10n.listVeterinarians.toUpperCase().replaceAll(' ', '\n'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: brandPrimary,
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    l10n.veterinariansBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: brandPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header Image
                Image.asset(
                  'assets/images/veterenaries.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
                const SizedBox(height: 20),

                // Search Bar
                _buildSearchBar(cardBg, brandPrimary, l10n),
                const SizedBox(height: 10),

                // Filter Dropdown
                _buildFilterDropdown(cardBg, brandPrimary, l10n),
                const SizedBox(height: 30),

                // List Section
                veterinariansAsync.when(
                  data: (veterinarians) {
                    if (veterinarians.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            l10n.noReportsFound,
                            style: const TextStyle(
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
                              l10n.allVeterinarians.toUpperCase(),
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
                          itemCount: veterinarians.length,
                          itemBuilder: (context, index) {
                            final vet = veterinarians[index];
                            return _buildVetCard(
                              vet,
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
          ref.read(veterinariansProvider.notifier).setSearchQuery(value);
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
                    ref.read(veterinariansProvider.notifier).setSearchQuery('');
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

  Widget _buildVetCard(
    ContactModel vet,
    Color cardBg,
    Color color,
    AppLocalizations l10n,
  ) {
    final name = vet.name;
    final address = vet.fullAddress;
    final imageUrl = vet.fullImageUrl;
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
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultIcon(color),
              ),
            )
          else
            _buildDefaultIcon(color),
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
                                DetailsShelterVeterinariansScreen(contact: vet),
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

  Widget _buildDefaultIcon(Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(Icons.medical_services_outlined, color: color, size: 30),
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
