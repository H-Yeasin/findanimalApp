import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import 'presentation/providers/contact_providers.dart';
import 'presentation/widgets/csfs_section.dart';

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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  CsfsSection(cardBg: cardBg, color: brandPrimary, l10n: l10n),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
