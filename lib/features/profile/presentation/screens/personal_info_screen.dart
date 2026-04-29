import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../partner_ads/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/profile_model.dart';
import '../../presentation/providers/profile_providers.dart';
import '../../presentation/providers/update_profile_provider.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _companyController = TextEditingController();
  final _professionController = TextEditingController();
  final _selfIntroductionController = TextEditingController();
  final _locationAddressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  bool _isEditing = false;
  bool _initialized = false;
  XFile? _selectedImage;
  String? _currentImageUrl;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _companyController.dispose();
    _professionController.dispose();
    _selfIntroductionController.dispose();
    _locationAddressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _hydrateForm(ProfileModel profile) {
    if (_initialized) return;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _addressController.text = profile.address;
    _companyController.text = profile.company ?? '';
    _professionController.text = profile.profession ?? '';
    _selfIntroductionController.text = profile.selfIntroduction ?? '';
    _locationAddressController.text = profile.location?.address ?? '';
    final coordinates = profile.location?.coordinates;
    if (coordinates != null && coordinates.length >= 2) {
      _longitudeController.text = coordinates[0].toString();
      _latitudeController.text = coordinates[1].toString();
    }
    _currentImageUrl = profile.profileImage?.secure_url;
    _initialized = true;
  }

  void _setEditMode(bool value) {
    if (!mounted) return;
    setState(() {
      _isEditing = value;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = <String, dynamic>{
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'country': _countryController.text.trim(),
      'company': _companyController.text.trim(),
      'profession': _professionController.text.trim(),
      'selfIntroduction': _selfIntroductionController.text.trim(),
      'locationAddress': _locationAddressController.text.trim(),
    };

    final latitude = double.tryParse(_latitudeController.text.trim());
    final longitude = double.tryParse(_longitudeController.text.trim());
    if (latitude != null) payload['latitude'] = latitude;
    if (longitude != null) payload['longitude'] = longitude;
    if (_selectedImage != null) {
      payload['image'] = await MultipartFile.fromFile(
        _selectedImage!.path,
        filename: _selectedImage!.path.split('/').last,
      );
    }

    payload.removeWhere(
      (key, value) => value == null || (value is String && value.isEmpty),
    );

    try {
      await ref.read(updateProfileProvider.notifier).submit(payload);
      _selectedImage = null;
      _initialized = false;
      ref.invalidate(myProfileProvider);
      ref.invalidate(currentUserProvider);
      _setEditMode(false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Update failed: $error')));
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null || !mounted) return;
    setState(() {
      _selectedImage = image;
    });
  }

  void _cancelEditing() {
    final profile = ref.read(myProfileProvider).valueOrNull;
    if (profile != null) {
      _firstNameController.text = profile.firstName;
      _lastNameController.text = profile.lastName;
      _emailController.text = profile.email;
      _phoneController.text = profile.phone;
      _addressController.text = profile.address;
      _companyController.text = profile.company ?? '';
      _professionController.text = profile.profession ?? '';
      _selfIntroductionController.text = profile.selfIntroduction ?? '';
      _locationAddressController.text = profile.location?.address ?? '';
      final coordinates = profile.location?.coordinates;
      if (coordinates != null && coordinates.length >= 2) {
        _longitudeController.text = coordinates[0].toString();
        _latitudeController.text = coordinates[1].toString();
      } else {
        _longitudeController.clear();
        _latitudeController.clear();
      }
      _currentImageUrl = profile.profileImage?.secure_url;
    }
    setState(() {
      _selectedImage = null;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(myProfileProvider);
    final isSaving = ref.watch(updateProfileProvider).isLoading;

    return PartnerScreenScaffold(
      header: _PersonalInfoHeader(
        isEditing: _isEditing,
        isSaving: isSaving,
        onEditTap: () => _setEditMode(!_isEditing),
        onSaveTap: _save,
        onCancelTap: _cancelEditing,
        imageUrl: _currentImageUrl,
        selectedImage: _selectedImage,
        onPickImage: _pickProfileImage,
      ),
      child: profileAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.only(top: 80),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
          child: Text(
            'Error: $error',
            style: const TextStyle(
              color: PartnerUiColors.brand,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        data: (profile) {
          _hydrateForm(profile);
          final isPartner = (profile.role ?? '').toLowerCase().contains(
            'partner',
          );
          return Padding(
            padding: const EdgeInsets.fromLTRB(26, 20, 26, 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    _isEditing ? 'Edit my information' : 'My information',
                    style: const TextStyle(
                      color: Color(0xFFD8C89D),
                      fontFamily: 'Impact',
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InfoField(
                    label: 'FIRST NAME',
                    controller: _firstNameController,
                    isEditing: _isEditing,
                    required: true,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'LAST NAME',
                    controller: _lastNameController,
                    isEditing: _isEditing,
                    required: true,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'E-MAIL',
                    controller: _emailController,
                    isEditing: false,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'PHONE',
                    controller: _phoneController,
                    isEditing: _isEditing,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'ADDRESS',
                    controller: _addressController,
                    isEditing: _isEditing,
                    maxLines: 2,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'CITY',
                    controller: _cityController,
                    isEditing: _isEditing,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'COUNTRY',
                    controller: _countryController,
                    isEditing: _isEditing,
                  ),
                  if (isPartner ||
                      _companyController.text.trim().isNotEmpty) ...[
                    const Divider(color: PartnerUiColors.brand),
                    _InfoField(
                      label: 'COMPANY',
                      controller: _companyController,
                      isEditing: _isEditing,
                    ),
                  ],
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'PROFESSION',
                    controller: _professionController,
                    isEditing: _isEditing,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'SELF INTRO',
                    controller: _selfIntroductionController,
                    isEditing: _isEditing,
                    maxLines: 3,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'LOCATION ADDRESS',
                    controller: _locationAddressController,
                    isEditing: _isEditing,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'LATITUDE',
                    controller: _latitudeController,
                    isEditing: _isEditing,
                    keyboardType: TextInputType.number,
                  ),
                  const Divider(color: PartnerUiColors.brand),
                  _InfoField(
                    label: 'LONGITUDE',
                    controller: _longitudeController,
                    isEditing: _isEditing,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  if (_isEditing)
                    SizedBox(
                      width: 240,
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PartnerUiColors.brand,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Impact',
                            fontSize: 18,
                          ),
                        ),
                        onPressed: isSaving ? null : _save,
                        child: isSaving
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
                            : const Text('Save changes'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PersonalInfoHeader extends StatelessWidget {
  const _PersonalInfoHeader({
    required this.isEditing,
    required this.isSaving,
    required this.onEditTap,
    required this.onSaveTap,
    required this.onCancelTap,
    required this.imageUrl,
    required this.selectedImage,
    required this.onPickImage,
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
    final hasNetwork = imageUrl != null && imageUrl!.trim().isNotEmpty;
    return SizedBox(
      height: 252,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (selectedImage != null)
            Image.file(
              File(selectedImage!.path),
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.9),
            )
          else if (hasNetwork)
            Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.9),
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/profile/personal_information_mock.png',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.9),
              ),
            )
          else
            Image.asset(
              'assets/images/profile/personal_information_mock.png',
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.9),
            ),
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
                        isEditing ? 'Save' : 'Edit',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Impact',
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment(0, 0.1),
            child: Text(
              'PERSONAL\nINFORMATION',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF8F0DC),
                fontFamily: 'Impact',
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
                child: const Text(
                  'Cancel',
                  style: TextStyle(
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image_outlined, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Change cover',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
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

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.controller,
    required this.isEditing,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final value = controller.text.trim().isEmpty ? '-' : controller.text.trim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: PartnerUiColors.brand,
                fontFamily: 'Impact',
                fontSize: 17,
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
                    style: const TextStyle(
                      color: PartnerUiColors.brand,
                      fontSize: 15,
                    ),
                    validator: required
                        ? (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }
                        : null,
                  )
                : Text(
                    value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: PartnerUiColors.brand,
                      fontFamily: 'Impact',
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
