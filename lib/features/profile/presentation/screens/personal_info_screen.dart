import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
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
  final _postalCodeController = TextEditingController();

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
    _postalCodeController.dispose();
    super.dispose();
  }

  void _hydrateForm(ProfileModel profile) {
    if (_initialized) return;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _addressController.text = profile.address;
    _cityController.text = profile.city ?? '';
    _countryController.text = profile.country ?? '';
    _companyController.text = profile.company ?? '';
    _professionController.text = profile.profession ?? '';
    _selfIntroductionController.text = profile.selfIntroduction ?? '';
    _locationAddressController.text = profile.location?.address ?? '';
    _postalCodeController.text = profile.postalCode ?? '';
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

    final previousImageUrl =
        _currentImageUrl ??
        ref.read(myProfileProvider).valueOrNull?.profileImage?.secure_url;
    final payload = <String, dynamic>{
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'postalCode': _postalCodeController.text.trim(),
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
      final updatedProfile = await ref
          .read(updateProfileProvider.notifier)
          .submit(payload);
      final updatedImageUrl = updatedProfile.profileImage?.secure_url;
      await _evictProfileImage(previousImageUrl);
      if (updatedImageUrl != previousImageUrl) {
        await _evictProfileImage(updatedImageUrl);
      }
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        await ref.read(authSessionProvider.notifier).updateCurrentUser(
              currentUser.copyWith(
                firstName: updatedProfile.firstName,
                lastName: updatedProfile.lastName,
                company: updatedProfile.company,
                phone: updatedProfile.phone,
                address: updatedProfile.address,
                profileImage: updatedImageUrl,
              ),
            );
      }
      ref.read(profileImageCacheBusterProvider.notifier).state =
          DateTime.now().millisecondsSinceEpoch;
      setState(() {
        _selectedImage = null;
        _currentImageUrl = updatedImageUrl;
        _initialized = false;
      });
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

  Future<void> _evictProfileImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.trim().isEmpty) return;
    await CachedNetworkImage.evictFromCache(imageUrl);
    await NetworkImage(imageUrl).evict();
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
      _cityController.text = profile.city ?? '';
      _countryController.text = profile.country ?? '';
      _postalCodeController.text = profile.postalCode ?? '';
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
    final profile = profileAsync.valueOrNull;
    final cacheBuster = ref.watch(profileImageCacheBusterProvider);
    final headerImageUrl =
        profileImageUrlWithCacheBuster(
          _currentImageUrl ?? profile?.profileImage?.secure_url,
          cacheBuster,
        );

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
              imageUrl: headerImageUrl,
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
                            style: AppTextStyles.condensedSectionTitle.copyWith(
                              color: AppColors.brandSecondary,
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
                            label: l10n.postalCode,
                            controller: _postalCodeController,
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
                                        style: AppTextStyles
                                            .condensedSectionTitle
                                            .copyWith(
                                              color: AppColors.white,
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
