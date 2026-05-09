import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:hesteka_frontend/core/utils/validators.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/my_animal_model.dart';
import '../../data/repositories/my_animals_repository.dart';
import '../providers/my_animals_provider.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class AddAnimalScreen extends ConsumerStatefulWidget {
  const AddAnimalScreen({this.animalId, this.initialAnimal, super.key});

  final String? animalId;
  final MyAnimalModel? initialAnimal;

  bool get isEditMode => animalId != null && animalId!.isNotEmpty;

  @override
  ConsumerState<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends ConsumerState<AddAnimalScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _breedController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  String? _initialImageUrl;
  String? _selectedSpecies;
  String? _selectedGender;
  String? _selectedAge;
  String? _hasMicrochip;
  String? _hasTattoo;
  String? _hasCollarOrHarness;
  bool _isSubmitting = false;

  static const _speciesOptions = ['Dog', 'Cat', 'Bird', 'Other'];
  static const _genderOptions = ['Male', 'Female'];
  static const _ageOptions = ['Junior', 'Adult', 'Senior'];
  static const _yesNoUnknownOptions = ['Yes', 'No', 'Unknown'];

  @override
  void initState() {
    super.initState();
    final animal = widget.initialAnimal;
    if (animal != null) {
      _titleController.text = animal.title;
      _descriptionController.text = animal.description;
      _breedController.text = animal.breed ?? '';
      _selectedSpecies = animal.species;
      _selectedGender = animal.gender;
      _selectedAge = animal.age;
      _hasMicrochip = animal.hasMicrochip;
      _hasTattoo = animal.hasTattoo;
      _hasCollarOrHarness = animal.hasCollarOrHarness;
      _initialImageUrl = animal.photo?.secureUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!widget.isEditMode && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload an animal image')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      MultipartFile? image;
      if (_selectedImage != null) {
        image = await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: _selectedImage!.path.split('/').last,
        );
      }

      if (widget.isEditMode) {
        await ref
            .read(myAnimalsRepositoryProvider)
            .update(
              id: widget.animalId!,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              species: _selectedSpecies!,
              breed: _breedController.text.trim(),
              gender: _selectedGender!,
              age: _selectedAge!,
              hasMicrochip: _hasMicrochip!,
              hasTattoo: _hasTattoo!,
              hasCollarOrHarness: _hasCollarOrHarness!,
              image: image,
            );
      } else {
        await ref
            .read(myAnimalsRepositoryProvider)
            .create(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              species: _selectedSpecies!,
              breed: _breedController.text.trim(),
              gender: _selectedGender!,
              age: _selectedAge!,
              hasMicrochip: _hasMicrochip!,
              hasTattoo: _hasTattoo!,
              hasCollarOrHarness: _hasCollarOrHarness!,
              image: image!,
            );
      }

      ref.invalidate(myAnimalsProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditMode
                ? 'Animal updated successfully'
                : 'Animal created successfully',
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create animal: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: widget.isEditMode ? 'EDIT\nANIMAL' : 'ADD\nANIMAL',
        imageUrl: AppAssets.homeHero,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PartnerSectionHeading('ANIMAL TITLE'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Enter animal title'),
                validator: (value) => Validators.required(
                  value,
                  requiredMessage: 'Title is required',
                ),
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('DESCRIPTION'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration('Write animal description'),
                validator: (value) => Validators.required(
                  value,
                  requiredMessage: 'Description is required',
                ),
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('SPECIES'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedSpecies,
                hint: 'Select species',
                items: _speciesOptions,
                onChanged: (value) => setState(() => _selectedSpecies = value),
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('BREED'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _breedController,
                decoration: _inputDecoration('Enter breed'),
                validator: (value) => Validators.required(
                  value,
                  requiredMessage: 'Breed is required',
                ),
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('GENDER'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedGender,
                hint: 'Select gender',
                items: _genderOptions,
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('AGE'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedAge,
                hint: 'Select age',
                items: _ageOptions,
                onChanged: (value) => setState(() => _selectedAge = value),
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('MICROCHIP'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _hasMicrochip,
                hint: 'Does the animal have a microchip?',
                items: _yesNoUnknownOptions,
                onChanged: (value) => setState(() => _hasMicrochip = value),
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('TATTOO'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _hasTattoo,
                hint: 'Does the animal have a tattoo?',
                items: _yesNoUnknownOptions,
                onChanged: (value) => setState(() => _hasTattoo = value),
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('COLLAR OR HARNESS'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _hasCollarOrHarness,
                hint: 'Does the animal wear one?',
                items: _yesNoUnknownOptions,
                onChanged: (value) =>
                    setState(() => _hasCollarOrHarness = value),
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('PHOTO'),
              const SizedBox(height: 8),
              if (_selectedImage != null ||
                  (_initialImageUrl?.isNotEmpty ?? false))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _selectedImage != null
                        ? Image.file(
                            File(_selectedImage!.path),
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 130,
                                  color: PartnerUiColors.grid,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Selected image preview unavailable',
                                  ),
                                ),
                          )
                        : Image.network(
                            _initialImageUrl!,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 130,
                                  color: PartnerUiColors.grid,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Current image unavailable',
                                  ),
                                ),
                          ),
                  ),
                ),
              InkWell(
                onTap: _pickImage,
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
                          _selectedImage == null
                              ? widget.isEditMode
                                    ? 'Select new image (optional)'
                                    : 'Select image'
                              : _selectedImage!.name,
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
              const SizedBox(height: 20),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PartnerUiColors.brand,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          widget.isEditMode ? 'UPDATE ANIMAL' : 'CREATE ANIMAL',
                          style: AppTextStyles.body.copyWith(
                            fontFamily: 'EricaOne',
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: _inputDecoration(hint),
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
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
      validator: (selectedValue) => Validators.required(
        selectedValue,
        requiredMessage: 'This field is required',
      ),
      onChanged: onChanged,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: PartnerUiColors.panel,
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
}
