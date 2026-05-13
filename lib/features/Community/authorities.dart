import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'presentation/providers/contact_providers.dart';
import 'presentation/widgets/contact_filter_panel.dart';
import 'data/models/contact_model.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';

class AuthoritiesScreen extends ConsumerStatefulWidget {
  const AuthoritiesScreen({super.key});

  @override
  ConsumerState<AuthoritiesScreen> createState() => _AuthoritiesScreenState();
}

class _AuthoritiesScreenState extends ConsumerState<AuthoritiesScreen> {
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

    final authoritiesAsync = ref.watch(authoritiesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: surface,
      body: AppBackground(
        showGridFromTop: true,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(authoritiesProvider.notifier).fetchContacts(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Header
                  AppTopBar(title: l10n.authoritiesTitle),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      l10n.authoritiesBody,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header Image
                  Image.asset(
                    AppAssets.authorities,
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
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Search Bar
                  _buildSearchBar(cardBg, brandPrimary, l10n),
                  const SizedBox(height: 10),
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
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
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
          ref.read(authoritiesProvider.notifier).setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: l10n.searchByName,
          hintStyle: AppTextStyles.caption.copyWith(
            color: color.withValues(alpha: 0.5),
            fontSize: 12,
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
                    ref.read(authoritiesProvider.notifier).setSearchQuery('');
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
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                contact.city ?? l10n.unknown,
                style: AppTextStyles.caption.copyWith(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                contact.phone ?? l10n.noPhone,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
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
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
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
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 9,
                    // fontWeight: FontWeight.w500,
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
