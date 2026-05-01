import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/my_animal_model.dart';
import '../../data/repositories/my_animals_repository.dart';
import '../providers/my_animals_provider.dart';

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
  final _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  String? _initialImageUrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final animal = widget.initialAnimal;
    if (animal != null) {
      _titleController.text = animal.title;
      _descriptionController.text = animal.description;
      _initialImageUrl = animal.photo?.secureUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
              image: image,
            );
      } else {
        await ref
            .read(myAnimalsRepositoryProvider)
            .create(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
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
        imageUrl:
            'https://images.unsplash.com/photo-1548767797-d8c844163c4c?auto=format&fit=crop&w=1200&q=80',
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              const PartnerSectionHeading('DESCRIPTION'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration('Write animal description'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
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
                          style: const TextStyle(
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
                          style: TextStyle(
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
