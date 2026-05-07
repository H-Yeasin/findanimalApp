import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/register_partner_request_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_ui_kit.dart';

class PartnerRegisterScreen extends ConsumerStatefulWidget {
  const PartnerRegisterScreen({super.key});

  @override
  ConsumerState<PartnerRegisterScreen> createState() =>
      _PartnerRegisterScreenState();
}

class _PartnerRegisterScreenState extends ConsumerState<PartnerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'France');
  final _companyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  XFile? _selectedLogo;
  double? _latitude;
  double? _longitude;
  String? _locationAddress;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null || !mounted) return;
    setState(() => _selectedLogo = image);
  }

  Future<void> _pickLocation() async {
    final result = await context.push<Map<String, dynamic>>(
      RouteNames.partnerRegisterLocationPicker,
    );
    if (result == null || !mounted) return;

    final lat = result['lat'];
    final lng = result['lng'];
    setState(() {
      _latitude = lat is num ? lat.toDouble() : double.tryParse('$lat');
      _longitude = lng is num ? lng.toDouble() : double.tryParse('$lng');
      _locationAddress = result['address'] as String?;
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLogo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fieldRequired(l10n.text('fieldLogo')))),
      );
      return;
    }

    if (_latitude == null || _longitude == null || _locationAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fieldRequired(l10n.text('fieldLocation')))),
      );
      return;
    }

    final request = RegisterPartnerRequestModel(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      country: _countryController.text.trim(),
      company: _companyController.text.trim(),
      latitude: _latitude!,
      longitude: _longitude!,
      locationAddress: _locationAddress!,
      logoPath: _selectedLogo!.path,
      password: _passwordController.text,
    );

    try {
      await ref.read(authActionProvider.notifier).registerPartner(request);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.partnerRegisterSuccess)));

      context.go(RouteNames.partnerLogin);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authErrorMessage(error))));
    }
  }

  String? _required(String? value, String field) {
    return Validators.required(
      value,
      requiredMessage: AppLocalizations.of(context).fieldRequired(field),
    );
  }

  String? _postalCodeValidator(String? value) {
    final l10n = AppLocalizations.of(context);
    final required = _required(value, l10n.text('fieldPostalCode'));
    if (required != null) return required;
    if (!RegExp(r'^\d{5}$').hasMatch(value!.trim())) {
      return l10n.text('postalCodeInvalid');
    }
    return null;
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: AppTextStyles.sectionTitle.copyWith(
          color: AuthUiColors.brand,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthFieldLabel(label),
        const SizedBox(height: 8),
        AuthPillTextField(
          controller: controller,
          hintText: hint,
          readOnly: false,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
        ),
      ],
    );
  }

  Widget _logoPicker(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthFieldLabel(l10n.text('partnerLogoLabel')),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: _pickLogo,
          child: Container(
            constraints: const BoxConstraints(minHeight: 78),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AuthUiColors.brand,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 54,
                    height: 54,
                    color: AuthUiColors.cream,
                    child: _selectedLogo == null
                        ? const Icon(
                            Icons.storefront,
                            color: AuthUiColors.brand,
                          )
                        : FutureBuilder(
                            future: _selectedLogo!.readAsBytes(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox.shrink();
                              }
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedLogo?.name ?? l10n.text('partnerLogoHint'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(color: Colors.white),
                  ),
                ),
                const Icon(Icons.upload_file, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _locationPicker(AppLocalizations l10n) {
    final hasLocation = _latitude != null && _longitude != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthFieldLabel(l10n.text('selectedLocationLabel')),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: _pickLocation,
          child: Container(
            constraints: const BoxConstraints(minHeight: 54),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AuthUiColors.brand,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasLocation
                        ? _locationAddress ?? l10n.text('selectedLocationLabel')
                        : l10n.text('chooseCompanyLocation'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(color: Colors.white),
                  ),
                ),
                const Icon(Icons.map_outlined, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authActionProvider).isLoading;
    final l10n = AppLocalizations.of(context);

    return AuthScreenScaffold(
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.partnerAuthGateway);
        }
      },
      onBottomTap: (_) => context.go(RouteNames.root),
      contentPadding: const EdgeInsets.fromLTRB(34, 18, 34, 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),
              AuthMainTitle(l10n.partnerRegisterTitle),
              const SizedBox(height: 22),
              _sectionTitle(l10n.text('partnerCompanyDetails')),
              _field(
                label: l10n.companyNameLabel,
                controller: _companyController,
                hint: l10n.companyNameHint,
                validator: (v) => _required(v, l10n.fieldCompanyName),
              ),
              const SizedBox(height: 16),
              _logoPicker(l10n),
              const SizedBox(height: 16),
              _field(
                label: l10n.addressLabel,
                controller: _addressController,
                hint: l10n.addressHint,
                validator: (v) => _required(v, l10n.fieldAddress),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: l10n.text('cityLabel'),
                      controller: _cityController,
                      hint: l10n.text('cityHint'),
                      validator: (v) => _required(v, l10n.text('fieldCity')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _field(
                      label: l10n.text('postalCodeLabel'),
                      controller: _postalCodeController,
                      hint: l10n.text('postalCodeHint'),
                      keyboardType: TextInputType.number,
                      validator: _postalCodeValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _field(
                label: l10n.text('countryLabel'),
                controller: _countryController,
                hint: l10n.text('countryHint'),
                validator: (v) => _required(v, l10n.country),
              ),
              const SizedBox(height: 16),
              _locationPicker(l10n),
              const SizedBox(height: 22),
              _sectionTitle(l10n.text('partnerContactDetails')),
              Row(
                children: [
                  Expanded(
                    child: _field(
                      label: l10n.text('contactFirstNameLabel'),
                      controller: _firstNameController,
                      hint: l10n.firstNameHint,
                      validator: (v) => _required(v, l10n.fieldFirstName),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _field(
                      label: l10n.text('contactLastNameLabel'),
                      controller: _lastNameController,
                      hint: l10n.lastNameHint,
                      validator: (v) => _required(v, l10n.fieldLastName),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _field(
                label: l10n.emailLabel,
                controller: _emailController,
                hint: l10n.emailHint,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.email(
                  value,
                  requiredMessage: l10n.emailRequired,
                  invalidMessage: l10n.emailInvalid,
                ),
              ),
              const SizedBox(height: 16),
              _field(
                label: l10n.phoneLabel,
                controller: _phoneController,
                hint: l10n.phoneHint,
                keyboardType: TextInputType.phone,
                validator: (v) => _required(v, l10n.fieldPhone),
              ),
              const SizedBox(height: 16),
              _field(
                label: l10n.passwordLabel,
                controller: _passwordController,
                hint: l10n.passwordHint,
                obscureText: true,
                validator: (value) => _required(value, l10n.fieldPassword),
              ),
              const SizedBox(height: 10),
              AuthPillTextField(
                controller: _confirmPasswordController,
                hintText: l10n.confirmPasswordHint,
                readOnly: false,
                obscureText: true,
                validator: (value) {
                  final base = _required(value, l10n.fieldConfirmPassword);
                  if (base != null) {
                    return base;
                  }
                  if (value != _passwordController.text) {
                    return l10n.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AuthOutlinePillButton(
                label: l10n.registerAsPartner,
                isLoading: isLoading,
                width: double.infinity,
                onPressed: isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
