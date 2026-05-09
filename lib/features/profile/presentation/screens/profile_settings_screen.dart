import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_locale_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  bool _locationEnabled = false;
  bool _locationToggleBusy = false;

  @override
  void initState() {
    super.initState();
    _syncLocationAuthorization();
  }

  Future<void> _syncLocationAuthorization() async {
    final enabled = await _hasLocationAuthorization();
    if (!mounted) return;
    setState(() {
      _locationEnabled = enabled;
    });
  }

  Future<bool> _hasLocationAuthorization() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<void> _onLocationToggleChanged(bool value) async {
    if (_locationToggleBusy) return;
    setState(() => _locationToggleBusy = true);

    try {
      if (value) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            setState(() {
              _locationEnabled = false;
              _locationToggleBusy = false;
            });
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Location permissions are permanently denied, we cannot request permissions.',
                ),
              ),
            );
          }
          setState(() {
            _locationEnabled = false;
            _locationToggleBusy = false;
          });
          return;
        }

        final enabled = await Geolocator.isLocationServiceEnabled();
        setState(() {
          _locationEnabled = enabled;
        });
      } else {
        // App cannot actually revoke system permissions,
        // but we can "disable" it in our local state if we had a backend flag.
        // For now, we just sync with system.
        await _syncLocationAuthorization();
      }
    } catch (e) {
      debugPrint('Error toggling location: $e');
    } finally {
      if (mounted) setState(() => _locationToggleBusy = false);
    }
  }

  Future<void> _openLanguageSheet(AppLanguage current) async {
    final pickedLanguage = await showModalBottomSheet<AppLanguage>(
      context: context,
      backgroundColor: PartnerUiColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Container(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: PartnerUiColors.brand.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.selectLanguage,
                style: AppTextStyles.body.copyWith(
                  color: PartnerUiColors.brand,
                  fontFamily: 'EricaOne',
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 24),
              ...AppLanguage.values.map((lang) {
                final isSelected = lang == current;
                return InkWell(
                  onTap: () => Navigator.pop(context, lang),
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? PartnerUiColors.brand
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: PartnerUiColors.brand,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            lang.name.toUpperCase(),
                            style: AppTextStyles.body.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : PartnerUiColors.brand,
                              fontFamily: 'EricaOne',
                              fontSize: 18,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check, color: Colors.white),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );

    if (pickedLanguage == null) return;
    await ref.read(appLocaleProvider.notifier).setLanguage(pickedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLanguage = AppLanguage.fromCode(
      ref.watch(appLocaleProvider).languageCode,
    );
    final currentUser = ref.watch(currentUserProvider);

    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: l10n.settingsTitle,
        imageUrl: AppAssets.settingsHeader,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(38, 20, 38, 34),
        child: Column(
          children: [
            PartnerSettingsRow(
              label: l10n.changePassword,
              value: '*******',
              onTap: () {
                final email = currentUser?.email.trim() ?? '';

                context.push(
                  '${RouteNames.forgotPassword}?email=${Uri.encodeComponent(email)}&lockEmail=1',
                );
              },
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerSettingsRow(
              label: l10n.registeredPaymentMethods,
              onTap: () => context.push(RouteNames.profilePaymentMethods),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: PartnerUiColors.brand,
                size: 36,
              ),
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerSettingsRow(
              label: l10n.language,
              onTap: () => _openLanguageSheet(currentLanguage),
              trailing: GestureDetector(
                onTap: () => _openLanguageSheet(currentLanguage),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      currentLanguage.name.toUpperCase(),
                      style: AppTextStyles.body.copyWith(
                        color: PartnerUiColors.brand,
                        fontFamily: 'EricaOne',
                        fontSize: 34 / 2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: PartnerUiColors.brand,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerSettingsRow(
              label: l10n.locationLabel,
              trailing: PartnerToggle(
                value: _locationEnabled,
                onChanged: _onLocationToggleChanged,
              ),
            ),
            // const Divider(color: PartnerUiColors.brand),
            // PartnerSettingsRow(
            //   label: l10n.darkLightMode,
            //   trailing: IconButton(
            //     onPressed: () {
            //       // TODO: Implement theme toggle
            //     },
            //     icon: const Icon(
            //       Icons.wb_sunny_rounded,
            //       color: PartnerUiColors.brand,
            //       size: 28,
            //     ),
            //   ),
            // ),
            const Divider(color: PartnerUiColors.brand),
            PartnerSettingsRow(
              label: l10n.privacyPolicy,
              onTap: () => context.push(RouteNames.privacyPolicy),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: PartnerUiColors.brand,
                size: 36,
              ),
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerSettingsRow(
              label: l10n.legalNotices,
              onTap: () => context.push(RouteNames.legalNotices),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: PartnerUiColors.brand,
                size: 36,
              ),
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerSettingsRow(
              label: l10n.contactSupport,
              onTap: () => context.push(RouteNames.contactSupport),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: PartnerUiColors.brand,
                size: 36,
              ),
            ),
            const Divider(color: PartnerUiColors.brand),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
