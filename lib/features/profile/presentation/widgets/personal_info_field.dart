import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../features/partner/presentation/widgets/partner_ui_kit.dart';

class PersonalInfoField extends StatelessWidget {
  const PersonalInfoField({
    required this.label,
    required this.controller,
    required this.isEditing,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final value = controller.text.trim().isEmpty ? '-' : controller.text.trim();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 17,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: isEditing
                ? TextFormField(
                    controller: controller,
                    maxLines: maxLines,
                    keyboardType: keyboardType,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: PartnerUiColors.grid),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: PartnerUiColors.brand),
                      ),
                    ),
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 18,
                      height: 1.2,
                    ),
                    validator: required
                        ? (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.required;
                            }
                            return null;
                          }
                        : null,
                  )
                : Text(
                    value,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 17,
                      height: 1.2,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
