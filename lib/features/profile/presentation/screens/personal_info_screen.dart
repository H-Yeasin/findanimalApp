import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/profile_model.dart';
import '../../presentation/providers/profile_providers.dart';
import '../../presentation/providers/update_profile_provider.dart';
import '../widgets/personal_info_field.dart';
import '../widgets/personal_info_header.dart';

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
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileUpdated)));
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.updateFailed(error.toString()))),
      );
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
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(myProfileProvider);
    final isSaving = ref.watch(updateProfileProvider).isLoading;

    return AppBackgroundScaffold(
      body: AppBackground(
        showGridFromTop: true,
        child: Column(
          children: [
            PersonalInfoHeader(
              isEditing: _isEditing,
              isSaving: isSaving,
              onEditTap: () => _setEditMode(!_isEditing),
              onSaveTap: _save,
              onCancelTap: _cancelEditing,
              imageUrl: _currentImageUrl,
              selectedImage: _selectedImage,
              onPickImage: _pickProfileImage,
            ),
            Expanded(
              child: profileAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.errorParam(error.toString()),
                    style: AppTextStyles.body.copyWith(
                      color: PartnerUiColors.brand,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                data: (profile) {
                  _hydrateForm(profile);
                  final isPartner = (profile.role ?? '').toLowerCase().contains(
                    'partner',
                  );
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(26, 20, 26, 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            _isEditing
                                ? l10n.editMyInformation
                                : l10n.myInformation,
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: const Color(0xFFD8C89D),
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 14),
                          PersonalInfoField(
                            label: l10n.firstName,
                            controller: _firstNameController,
                            isEditing: _isEditing,
                            required: true,
                          ),
                          const Divider(color: PartnerUiColors.brand),
                          PersonalInfoField(
                            label: l10n.lastName,
                            controller: _lastNameController,
                            isEditing: _isEditing,
                            required: true,
                          ),
                          const Divider(color: PartnerUiColors.brand),
                          PersonalInfoField(
                            label: l10n.email,
                            controller: _emailController,
                            isEditing: false,
                          ),
                          const Divider(color: PartnerUiColors.brand),
                          PersonalInfoField(
                            label: l10n.phone,
                            controller: _phoneController,
                            isEditing: _isEditing,
                          ),
                          const Divider(color: PartnerUiColors.brand),
                          PersonalInfoField(
                            label: l10n.address,
                            controller: _addressController,
                            isEditing: _isEditing,
                            maxLines: 2,
                          ),
                          const Divider(color: PartnerUiColors.brand),
                          PersonalInfoField(
                            label: l10n.city,
                            controller: _cityController,
                            isEditing: _isEditing,
                          ),
                          const Divider(color: PartnerUiColors.brand),
                          PersonalInfoField(
                            label: l10n.country,
                            controller: _countryController,
                            isEditing: _isEditing,
                          ),
                          if (isPartner ||
                              _companyController.text.trim().isNotEmpty) ...[
                            const Divider(color: PartnerUiColors.brand),
                            PersonalInfoField(
                              label: l10n.company,
                              controller: _companyController,
                              isEditing: _isEditing,
                            ),
                          ],
                          const Divider(color: PartnerUiColors.brand),
                          PersonalInfoField(
                            label: l10n.profession,
                            controller: _professionController,
                            isEditing: _isEditing,
                          ),
                          const Divider(color: PartnerUiColors.brand),
                          PersonalInfoField(
                            label: l10n.selfIntro,
                            controller: _selfIntroductionController,
                            isEditing: _isEditing,
                            maxLines: 3,
                          ),
                          const Divider(color: PartnerUiColors.brand),
                          PersonalInfoField(
                            label: l10n.locationAddress,
                            controller: _locationAddressController,
                            isEditing: _isEditing,
                          ),
                          const Divider(color: PartnerUiColors.brand),
                          const SizedBox(height: 24),
                          if (_isEditing)
                            SizedBox(
                              width: 400,
                              height: 42,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PartnerUiColors.brand,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                                onPressed: isSaving ? null : _save,
                                child: isSaving
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        l10n.saveChanges,
                                        style: AppTextStyles.button.copyWith(
                                          fontFamily: AppTextStyles.titleFont,
                                          fontSize: 18,
                                        ),
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
