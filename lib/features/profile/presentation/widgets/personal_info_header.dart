import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../features/partner/presentation/widgets/partner_ui_kit.dart';

class PersonalInfoHeader extends StatelessWidget {
  const PersonalInfoHeader({
    required this.isEditing,
    required this.isSaving,
    required this.onEditTap,
    required this.onSaveTap,
    required this.onCancelTap,
    required this.imageUrl,
    required this.selectedImage,
    required this.onPickImage,
    super.key,
  });

  final bool isEditing;
  final bool isSaving;
  final VoidCallback onEditTap;
  final VoidCallback onSaveTap;
  final VoidCallback onCancelTap;
  final String? imageUrl;
  final XFile? selectedImage;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasNetwork = imageUrl != null && imageUrl!.trim().isNotEmpty;
    return SizedBox(
      height: 252,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasNetwork)
            Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.9),
            )
          else
            Icon(Icons.person, size: 100, color: Colors.grey),

          Container(color: Colors.black.withValues(alpha: 0.10)),
          const Positioned(left: 22, top: 38, child: PartnerBackButton()),
          Positioned(
            right: 22,
            top: 38,
            child: InkWell(
              onTap: isSaving ? null : (isEditing ? onSaveTap : onEditTap),
              customBorder: const StadiumBorder(),
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PartnerUiColors.brand,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        isEditing ? l10n.save : l10n.edit,
                        style: AppTextStyles.button.copyWith(
                          fontFamily: AppTextStyles.titleFont,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.1),
            child: Text(
              l10n.personalInformation,
              textAlign: TextAlign.center,
              style: AppTextStyles.display.copyWith(
                color: const Color(0xFFF8F0DC),
                fontSize: 56 / 2,
                height: 1.05,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (isEditing && !isSaving)
            Positioned(
              right: 22,
              top: 82,
              child: TextButton(
                onPressed: onCancelTap,
                child: Text(
                  l10n.cancel,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          if (isEditing && !isSaving)
            Positioned(
              right: 22,
              bottom: 14,
              child: InkWell(
                onTap: onPickImage,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.image_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.changeCover,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
