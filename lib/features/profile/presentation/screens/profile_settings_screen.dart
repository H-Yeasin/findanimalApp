import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_locale_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';

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
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Location service is off. Please enable it in phone settings.',
                ),
              ),
            );
          }
          await Geolocator.openLocationSettings();
          await _syncLocationAuthorization();
          return;
        }

        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.deniedForever) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Location permission is permanently denied. Open app settings to allow it.',
                ),
              ),
            );
          }
          await Geolocator.openAppSettings();
          await _syncLocationAuthorization();
          return;
        }

        if (!mounted) return;
        setState(() {
          _locationEnabled =
              permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always;
        });
        return;
      }

      if (!mounted) return;
      final shouldOpenSettings = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Disable location access'),
            content: const Text(
              'To disable location permission, open your app settings and set location to "Never".',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Open settings'),
              ),
            ],
          );
        },
      );

      if (shouldOpenSettings == true) {
        await Geolocator.openAppSettings();
      }

      await _syncLocationAuthorization();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update location setting: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _locationToggleBusy = false);
      }
    }
  }

  Future<void> _openLanguageSheet(AppLanguage selectedLanguage) async {
    final pickedLanguage = await showModalBottomSheet<AppLanguage>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: PartnerUiColors.panel,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: PartnerUiColors.grid),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguage.values.map((language) {
              final isSelected = language == selectedLanguage;
              return InkWell(
                onTap: () => Navigator.of(context).pop(language),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          language.labelFr,
                          style: const TextStyle(
                            color: PartnerUiColors.brand,
                            fontFamily: 'EricaOne',
                            fontSize: 28 / 2,
                          ),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? PartnerUiColors.brand
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: PartnerUiColors.brand),
                        ),
                        alignment: Alignment.center,
                        child: isSelected
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
        imageUrl:
            'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=1200&q=80',
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(38, 20, 38, 34),
        child: Column(
          children: [
            PartnerSettingsRow(
              label: l10n.changePassword,
              value: '************',
              onTap: () {
                final email = currentUser?.email.trim() ?? '';
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Could not find account email. Please login again.',
                      ),
                    ),
                  );
                  return;
                }

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
                child: Container(
                  width: 150,
                  height: 46,
                  decoration: BoxDecoration(
                    color: PartnerUiColors.panel,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: PartnerUiColors.grid),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentLanguage.labelEn,
                        style: const TextStyle(
                          color: PartnerUiColors.brand,
                          fontFamily: 'EricaOne',
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: PartnerUiColors.brand,
                        size: 26,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerSettingsRow(
              label: l10n.darkLightMode,
              trailing: Icon(
                Icons.wb_sunny_outlined,
                color: PartnerUiColors.brand,
                size: 32,
              ),
            ),
            const Divider(color: PartnerUiColors.brand),
            PartnerSettingsRow(
              label: l10n.locationAuthorization,
              trailing: PartnerToggle(
                value: _locationEnabled,
                onChanged: _onLocationToggleChanged,
              ),
            ),
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
            const SizedBox(height: 86),
            Text(
              l10n.deleteMyAccount,
              style: TextStyle(
                color: PartnerUiColors.brand,
                fontFamily: 'EricaOne',
                fontSize: 38 / 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
