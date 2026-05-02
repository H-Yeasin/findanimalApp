import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'presentation/providers/contact_providers.dart';
import 'data/models/contact_model.dart';
import '../../core/localization/app_localizations.dart';

class AuthoritiesScreen extends ConsumerStatefulWidget {
  const AuthoritiesScreen({super.key});

  @override
  ConsumerState<AuthoritiesScreen> createState() => _AuthoritiesScreenState();
}

class _AuthoritiesScreenState extends ConsumerState<AuthoritiesScreen> {
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

    final authoritiesAsync = ref.watch(authoritiesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(authoritiesProvider.notifier).fetchContacts(),
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
                  l10n.authoritiesTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: brandPrimary,
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    l10n.authoritiesBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: brandPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header Image
                Image.asset(
                  'assets/images/authorities.png',
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

                Text(
                  l10n.gendarmeries,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: brandPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                // Search Bar
                _buildSearchBar(cardBg, brandPrimary, l10n),
                const SizedBox(height: 10),

                // Filter Dropdown
                _buildFilterDropdown(cardBg, brandPrimary, l10n),
                const SizedBox(height: 20),

                // List Section
                authoritiesAsync.when(
                  data: (authorities) {
                    if (authorities.isEmpty) {
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
                    return _buildAuthorityGrid(
                      authorities,
                      cardBg,
                      brandPrimary,
                      l10n,
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
          ref.read(authoritiesProvider.notifier).setSearchQuery(value);
        },
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: color),
          hintText: l10n.searchByName,
          hintStyle: TextStyle(
            color: color.withValues(alpha: 0.5),
            fontSize: 12,
          ),
          border: InputBorder.none,
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(authoritiesProvider.notifier).setSearchQuery('');
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
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: color),
        ],
      ),
    );
  }

  Widget _buildAuthorityGrid(
    List<ContactModel> authorities,
    Color cardBg,
    Color color,
    AppLocalizations l10n,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.65,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: authorities
          .map((a) => _buildAuthorityCard(a, cardBg, color, l10n))
          .toList(),
    );
  }

  Widget _buildAuthorityCard(
    ContactModel contact,
    Color cardBg,
    Color color,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                contact.name.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                contact.city ?? l10n.unknown,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                contact.phone ?? l10n.noPhone,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              if (contact.phone != null) {
                _launchCaller(contact.phone!);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                l10n.toCall.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: color, size: 12),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  contact.country ?? 'New Aquitaine',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchCaller(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri launchUri = Uri.parse('tel:$cleanNumber');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}
