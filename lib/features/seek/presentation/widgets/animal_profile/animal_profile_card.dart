import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/core/utils/formatters.dart';
import 'package:url_launcher/url_launcher.dart';

import 'animal_profile_data.dart';

class AnimalProfileCard extends StatefulWidget {
  final AnimalProfileData data;

  const AnimalProfileCard({super.key, required this.data});

  @override
  State<AnimalProfileCard> createState() => _AnimalProfileCardState();
}

class _AnimalProfileCardState extends State<AnimalProfileCard> {
  bool _showContactInfo = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final data = widget.data;
    String buttonText = l10n.contactOwner;
    if (data.status.toLowerCase() == 'found') {
      buttonText = l10n.knowOwner;
    }
    if (data.status.toLowerCase().contains('injured')) {
      buttonText = l10n.availableToTakeCare;
    }

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === TOP ROW: image left + info right ===
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── LEFT: Name + Image ───
                SizedBox(
                  width: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name.toUpperCase(),
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 26,
                          letterSpacing: 0.8,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Image without golden frame
                      Expanded(
                        child: Container(
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: data.isPlaceholder
                                ? Container(
                                    color: const Color(0xFFFDF6ED),
                                    child: const Center(
                                      child: Icon(
                                        Icons.pets,
                                        color: Color(0xFFBA4A22),
                                        size: 50,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    data.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.pets,
                                        color: Color(0xFFBA4A22),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // ─── RIGHT: Owner info + details + status ───
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Owner row
                      Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFFBA4A22),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 11,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.ownerName == 'Owner'
                                ? l10n.owner
                                : data.ownerName,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            Formatters.date(
                              data.eventDate.toLocal(),
                              pattern: l10n.profileDateFormat,
                              locale: l10n.locale.languageCode,
                            ),
                            style: AppTextStyles.caption.copyWith(
                              color: Color(0xFFD3A482),
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Details: Adult | Cat | Angora | Lost
                      Text(
                        _buildLocalizedDetails(l10n, data),
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFBA4A22),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          l10n.currentStatus(
                            _localizeStatus(l10n, data.status),
                          ),
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        '"${data.description}"',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10.5,
                          height: 1.4,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showContactInfo = !_showContactInfo;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBA4A22),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              _showContactInfo
                                  ? l10n.hideContactInfo
                                  : buttonText,
                              style: AppTextStyles.button.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_showContactInfo) ...[
                        const SizedBox(height: 10),
                        _OwnerContactInfo(data: data),
                      ],
                      if (data.address != null && data.address!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          data.address!,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildLocalizedDetails(
    AppLocalizations l10n,
    AnimalProfileData data,
  ) {
    final details = [
      _localizeAge(l10n, data.age),
      _localizeSpecies(l10n, data.species),
      data.breed.trim(),
      _localizeStatus(l10n, data.status),
    ].where((value) => value.isNotEmpty).toList();

    return details.join(' | ');
  }

  String _localizeSpecies(AppLocalizations l10n, String value) {
    switch (value.trim().toLowerCase()) {
      case 'dog':
        return l10n.reportStep1Dog;
      case 'cat':
        return l10n.reportStep1Cat;
      case 'bird':
        return l10n.reportStep1Bird;
      case 'rabbit':
        return l10n.reportStep1Rabbit;
      case 'other':
        return l10n.reportStep1Other;
      default:
        return value;
    }
  }

  String _localizeAge(AppLocalizations l10n, String value) {
    switch (value.trim().toLowerCase()) {
      case 'junior':
        return l10n.addAnimalAgeJunior;
      case 'adult':
        return l10n.addAnimalAgeAdult;
      case 'senior':
        return l10n.addAnimalAgeSenior;
      default:
        return value;
    }
  }

  String _localizeStatus(AppLocalizations l10n, String value) {
    switch (value.trim().toLowerCase()) {
      case 'all':
        return l10n.statusAll;
      case 'lost':
      case 'missing':
        return l10n.reportStep1Lost;
      case 'found':
        return l10n.reportStep1Found;
      case 'spotted':
      case 'sighted':
        return l10n.reportStep1Spotted;
      case 'injured':
        return l10n.reportStep1Injured;
      case 'rescued':
        return l10n.statusRescued;
      default:
        return value;
    }
  }
}

class _OwnerContactInfo extends StatelessWidget {
  const _OwnerContactInfo({required this.data});

  final AnimalProfileData data;

  @override
  Widget build(BuildContext context) {
    final visiblePhone = data.isPhoneVisible && _hasText(data.contactPhone);
    final visibleEmail = data.isEmailVisible && _hasText(data.contactEmail);

    if (!visiblePhone && !visibleEmail) {
      return Text(
        AppLocalizations.of(context).noPublicContactInfo,
        style: AppTextStyles.caption.copyWith(
          fontSize: 10.5,
          height: 1.3,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (visiblePhone)
          _ContactLine(
            icon: Icons.phone,
            value: data.contactPhone!,
            onTap: () => _launchContact(context, 'tel', data.contactPhone!),
          ),
        if (visibleEmail)
          _ContactLine(
            icon: Icons.email_outlined,
            value: data.contactEmail!,
            onTap: () => _launchContact(context, 'mailto', data.contactEmail!),
          ),
      ],
    );
  }

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

  Future<void> _launchContact(
    BuildContext context,
    String scheme,
    String value,
  ) async {
    final uri = Uri(scheme: scheme, path: value.trim());
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).couldNotOpenContactApp),
        ),
      );
    }
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.icon, required this.value, this.onTap});

  final IconData icon;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFBA4A22), size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFBA4A22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
