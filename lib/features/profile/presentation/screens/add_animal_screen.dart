import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/my_animal_model.dart';
import '../../data/repositories/my_animals_repository.dart';
import '../providers/my_animals_provider.dart';
import '../widgets/add_animal_form_sections.dart';

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
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;
    if (!widget.isEditMode && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addAnimalImageRequired)),
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
                ? l10n.addAnimalUpdateSuccess
                : l10n.addAnimalCreateSuccess,
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addAnimalSubmitError(error.toString()))),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: widget.isEditMode ? l10n.addAnimalTitleEdit : l10n.addAnimalTitleAdd,
        imageUrl: AppAssets.homeHero,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
        child: AddAnimalFormSections(
          formKey: _formKey,
          titleController: _titleController,
          descriptionController: _descriptionController,
          breedController: _breedController,
          selectedSpecies: _selectedSpecies,
          selectedGender: _selectedGender,
          selectedAge: _selectedAge,
          hasMicrochip: _hasMicrochip,
          hasTattoo: _hasTattoo,
          hasCollarOrHarness: _hasCollarOrHarness,
          selectedImage: _selectedImage,
          initialImageUrl: _initialImageUrl,
          isEditMode: widget.isEditMode,
          isSubmitting: _isSubmitting,
          onSpeciesChanged: (value) => setState(() => _selectedSpecies = value),
          onGenderChanged: (value) => setState(() => _selectedGender = value),
          onAgeChanged: (value) => setState(() => _selectedAge = value),
          onHasMicrochipChanged:
              (value) => setState(() => _hasMicrochip = value),
          onHasTattooChanged: (value) => setState(() => _hasTattoo = value),
          onHasCollarOrHarnessChanged:
              (value) => setState(() => _hasCollarOrHarness = value),
          onPickImage: _pickImage,
          onSubmit: _submit,
        ),
      ),
    );
  }
}
