import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/core/utils/validators.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import 'package:image_picker/image_picker.dart';

class AddAnimalFormSections extends StatelessWidget {
  const AddAnimalFormSections({
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.breedController,
    required this.selectedSpecies,
    required this.selectedGender,
    required this.selectedAge,
    required this.hasMicrochip,
    required this.hasTattoo,
    required this.hasCollarOrHarness,
    required this.selectedImage,
    required this.initialImageUrl,
    required this.isEditMode,
    required this.isSubmitting,
    required this.onSpeciesChanged,
    required this.onGenderChanged,
    required this.onAgeChanged,
    required this.onHasMicrochipChanged,
    required this.onHasTattooChanged,
    required this.onHasCollarOrHarnessChanged,
    required this.onPickImage,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController breedController;
  final String? selectedSpecies;
  final String? selectedGender;
  final String? selectedAge;
  final String? hasMicrochip;
  final String? hasTattoo;
  final String? hasCollarOrHarness;
  final XFile? selectedImage;
  final String? initialImageUrl;
  final bool isEditMode;
  final bool isSubmitting;
  final ValueChanged<String?> onSpeciesChanged;
  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<String?> onAgeChanged;
  final ValueChanged<String?> onHasMicrochipChanged;
  final ValueChanged<String?> onHasTattooChanged;
  final ValueChanged<String?> onHasCollarOrHarnessChanged;
  final VoidCallback onPickImage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final speciesOptions = [
      _AddAnimalDropdownOption(value: 'Dog', label: l10n.reportStep1Dog),
      _AddAnimalDropdownOption(value: 'Cat', label: l10n.reportStep1Cat),
      _AddAnimalDropdownOption(value: 'Bird', label: l10n.reportStep1Bird),
      _AddAnimalDropdownOption(value: 'Other', label: l10n.reportStep1Other),
    ];
    final genderOptions = [
      _AddAnimalDropdownOption(value: 'Male', label: l10n.reportStep1Male),
      _AddAnimalDropdownOption(value: 'Female', label: l10n.reportStep1Female),
    ];
    final ageOptions = [
      _AddAnimalDropdownOption(value: 'Junior', label: l10n.addAnimalAgeJunior),
      _AddAnimalDropdownOption(value: 'Adult', label: l10n.addAnimalAgeAdult),
      _AddAnimalDropdownOption(value: 'Senior', label: l10n.addAnimalAgeSenior),
    ];
    final yesNoUnknownOptions = [
      _AddAnimalDropdownOption(value: 'Yes', label: l10n.yes),
      _AddAnimalDropdownOption(value: 'No', label: l10n.no),
      _AddAnimalDropdownOption(value: 'Unknown', label: l10n.dontKnow),
    ];

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AddAnimalSectionTitle(l10n.addAnimalSectionTitle),
          const SizedBox(height: 8),
          _AddAnimalTextField(
            controller: titleController,
            hint: l10n.addAnimalHintTitle,
            requiredMessage: l10n.addAnimalValidationTitle,
          ),
          const SizedBox(height: 14),
          _AddAnimalSectionTitle(l10n.addAnimalSectionDescription),
          const SizedBox(height: 8),
          _AddAnimalTextField(
            controller: descriptionController,
            hint: l10n.addAnimalHintDescription,
            requiredMessage: l10n.addAnimalValidationDescription,
            maxLines: 4,
          ),
          const SizedBox(height: 14),
          _AddAnimalSectionTitle(l10n.addAnimalSectionSpecies),
          const SizedBox(height: 8),
          _AddAnimalDropdownField(
            value: selectedSpecies,
            hint: l10n.addAnimalHintSpecies,
            items: speciesOptions,
            onChanged: onSpeciesChanged,
          ),
          const SizedBox(height: 14),
          _AddAnimalSectionTitle(l10n.addAnimalSectionBreed),
          const SizedBox(height: 8),
          _AddAnimalTextField(
            controller: breedController,
            hint: l10n.addAnimalHintBreed,
            requiredMessage: l10n.addAnimalValidationBreed,
          ),
          const SizedBox(height: 14),
          _AddAnimalSectionTitle(l10n.addAnimalSectionGender),
          const SizedBox(height: 8),
          _AddAnimalDropdownField(
            value: selectedGender,
            hint: l10n.addAnimalHintGender,
            items: genderOptions,
            onChanged: onGenderChanged,
          ),
          const SizedBox(height: 14),
          _AddAnimalSectionTitle(l10n.addAnimalSectionAge),
          const SizedBox(height: 8),
          _AddAnimalDropdownField(
            value: selectedAge,
            hint: l10n.addAnimalHintAge,
            items: ageOptions,
            onChanged: onAgeChanged,
          ),
          const SizedBox(height: 14),
          _AddAnimalSectionTitle(l10n.addAnimalSectionMicrochip),
          const SizedBox(height: 8),
          _AddAnimalDropdownField(
            value: hasMicrochip,
            hint: l10n.addAnimalHintMicrochip,
            items: yesNoUnknownOptions,
            onChanged: onHasMicrochipChanged,
          ),
          const SizedBox(height: 14),
          _AddAnimalSectionTitle(l10n.addAnimalSectionTattoo),
          const SizedBox(height: 8),
          _AddAnimalDropdownField(
            value: hasTattoo,
            hint: l10n.addAnimalHintTattoo,
            items: yesNoUnknownOptions,
            onChanged: onHasTattooChanged,
          ),
          const SizedBox(height: 14),
          _AddAnimalSectionTitle(l10n.addAnimalSectionCollarOrHarness),
          const SizedBox(height: 8),
          _AddAnimalDropdownField(
            value: hasCollarOrHarness,
            hint: l10n.addAnimalHintCollarOrHarness,
            items: yesNoUnknownOptions,
            onChanged: onHasCollarOrHarnessChanged,
          ),
          const SizedBox(height: 14),
          _AddAnimalSectionTitle(l10n.addAnimalSectionPhoto),
          const SizedBox(height: 8),
          _AddAnimalPhotoPicker(
            selectedImage: selectedImage,
            initialImageUrl: initialImageUrl,
            isEditMode: isEditMode,
            onPickImage: onPickImage,
          ),
          const SizedBox(height: 20),
          _AddAnimalSubmitButton(
            isSubmitting: isSubmitting,
            isEditMode: isEditMode,
            onPressed: onSubmit,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _AddAnimalSectionTitle extends StatelessWidget {
  const _AddAnimalSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return PartnerSectionHeading(title);
  }
}

class _AddAnimalTextField extends StatelessWidget {
  const _AddAnimalTextField({
    required this.controller,
    required this.hint,
    required this.requiredMessage,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final String requiredMessage;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: buildAddAnimalInputDecoration(hint),
      validator: (value) =>
          Validators.required(value, requiredMessage: requiredMessage),
    );
  }
}

class _AddAnimalDropdownField extends StatelessWidget {
  const _AddAnimalDropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final String hint;
  final List<_AddAnimalDropdownOption> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: buildAddAnimalInputDecoration(),
      hint: Text(hint, style: _addAnimalHintStyle),
      dropdownColor: PartnerUiColors.panel,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: PartnerUiColors.brand,
      ),
      style: AppTextStyles.body.copyWith(
        color: PartnerUiColors.brand,
        fontWeight: FontWeight.w600,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item.value,
              child: Text(item.label),
            ),
          )
          .toList(),
      validator: (selectedValue) => Validators.required(
        selectedValue,
        requiredMessage: AppLocalizations.of(context).addAnimalFieldRequired,
      ),
      onChanged: onChanged,
    );
  }
}

class _AddAnimalPhotoPicker extends StatelessWidget {
  const _AddAnimalPhotoPicker({
    required this.selectedImage,
    required this.initialImageUrl,
    required this.isEditMode,
    required this.onPickImage,
  });

  final XFile? selectedImage;
  final String? initialImageUrl;
  final bool isEditMode;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasPreview =
        selectedImage != null || (initialImageUrl?.isNotEmpty ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasPreview)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: selectedImage != null
                  ? Image.file(
                      File(selectedImage!.path),
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildImageFallback(
                            l10n.addAnimalSelectedImagePreviewUnavailable,
                          ),
                    )
                  : Image.network(
                      initialImageUrl!,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildImageFallback(
                            l10n.addAnimalCurrentImageUnavailable,
                          ),
                    ),
            ),
          ),
        InkWell(
          onTap: onPickImage,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: PartnerUiColors.panel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: PartnerUiColors.brand),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedImage == null
                        ? isEditMode
                              ? l10n.addAnimalSelectNewImageOptional
                              : l10n.addAnimalSelectImage
                        : selectedImage!.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: PartnerUiColors.brand,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: PartnerUiColors.brand,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageFallback(String message) {
    return Container(
      height: 130,
      color: PartnerUiColors.grid,
      alignment: Alignment.center,
      child: Text(message),
    );
  }
}

class _AddAnimalSubmitButton extends StatelessWidget {
  const _AddAnimalSubmitButton({
    required this.isSubmitting,
    required this.isEditMode,
    required this.onPressed,
  });

  final bool isSubmitting;
  final bool isEditMode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: PartnerUiColors.brand,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                isEditMode
                    ? AppLocalizations.of(context).addAnimalUpdateButton
                    : AppLocalizations.of(context).addAnimalCreateButton,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class _AddAnimalDropdownOption {
  const _AddAnimalDropdownOption({required this.value, required this.label});

  final String value;
  final String label;
}

InputDecoration buildAddAnimalInputDecoration([String? hint]) {
  return InputDecoration(
    hintText: hint,
    hintStyle: _addAnimalHintStyle,
    filled: true,
    fillColor: PartnerUiColors.lightText,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: PartnerUiColors.brand),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: PartnerUiColors.brand),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: PartnerUiColors.brand, width: 1.2),
    ),
  );
}

TextStyle get _addAnimalHintStyle =>
    AppTextStyles.body.copyWith(color: AppColors.red);
