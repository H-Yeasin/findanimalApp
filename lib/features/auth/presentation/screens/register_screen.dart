import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/register_request_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_ui_kit.dart';

class AuthRegisterScreen extends ConsumerStatefulWidget {
  const AuthRegisterScreen({super.key});

  @override
  ConsumerState<AuthRegisterScreen> createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends ConsumerState<AuthRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = RegisterRequestModel(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      password: _passwordController.text,
    );

    try {
      await ref.read(authActionProvider.notifier).registerUser(request);
      
      if (!mounted) return;
      
      final l10nSuccess = AppLocalizations.of(context);
      showAuthSnackBar(context, l10nSuccess.registerSuccess, isError: false);
      context.go(RouteNames.login);
    } catch (error) {
      if (!mounted) {
        return;
      }
      showAuthSnackBar(context, authErrorMessage(error, l10n));
    }
  }

  @override
  Widget build(BuildContext context) {

    final isLoading = ref.watch(authActionProvider).isLoading;
    final l10n = AppLocalizations.of(context);

    return AuthScreenScaffold(
      isLoading: isLoading,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.account);
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
              AuthMainTitle(l10n.registerTitle),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthFieldLabel(l10n.firstNameLabel),
                        const SizedBox(height: 8),
                        AuthPillTextField(
                          controller: _firstNameController,
                          hintText: l10n.firstNameHint,
                          readOnly: false,
                          validator: (v) => Validators.required(
                            v,
                            requiredMessage: l10n.fieldRequired(
                              l10n.fieldFirstName,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthFieldLabel(l10n.lastNameLabel),
                        const SizedBox(height: 8),
                        AuthPillTextField(
                          readOnly: false,
                          controller: _lastNameController,
                          hintText: l10n.lastNameHint,
                          validator: (v) => Validators.required(
                            v,
                            requiredMessage: l10n.fieldRequired(
                              l10n.fieldLastName,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AuthFieldLabel(l10n.emailLabel),
              const SizedBox(height: 8),
              AuthPillTextField(
                controller: _emailController,
                hintText: l10n.emailHint,
                readOnly: false,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.email(
                  value,
                  requiredMessage: l10n.emailRequired,
                  invalidMessage: l10n.emailInvalid,
                ),
              ),
              const SizedBox(height: 10),
              AuthPillTextField(
                controller: _confirmEmailController,
                hintText: l10n.confirmEmailHint,
                readOnly: false,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final base = Validators.email(
                    value,
                    requiredMessage: l10n.emailRequired,
                    invalidMessage: l10n.emailInvalid,
                  );
                  if (base != null) {
                    return base;
                  }
                  if (value!.trim() != _emailController.text.trim()) {
                    return l10n.emailsDoNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthFieldLabel(l10n.phoneLabel),
              const SizedBox(height: 8),
              AuthPillTextField(
                controller: _phoneController,
                hintText: l10n.phoneHint,
                readOnly: false,
                keyboardType: TextInputType.phone,
                validator: (v) => Validators.required(
                  v,
                  requiredMessage: l10n.fieldRequired(l10n.fieldPhone),
                ),
              ),
              const SizedBox(height: 16),
              AuthFieldLabel(l10n.addressLabel),
              const SizedBox(height: 8),
              AuthPillTextField(
                controller: _addressController,
                hintText: l10n.addressHint,
                readOnly: false,
                validator: (v) => Validators.required(
                  v,
                  requiredMessage: l10n.fieldRequired(l10n.fieldAddress),
                ),
              ),
              const SizedBox(height: 16),
              AuthFieldLabel(l10n.passwordLabel),
              const SizedBox(height: 8),
              AuthPillTextField(
                controller: _passwordController,
                hintText: l10n.passwordHint,
                obscureText: _obscurePassword,
                readOnly: false,
                suffix: AuthPasswordVisibilityToggle(
                  obscureText: _obscurePassword,
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (value) => Validators.required(
                  value,
                  requiredMessage: l10n.fieldRequired(l10n.fieldPassword),
                ),
              ),
              const SizedBox(height: 10),
              AuthPillTextField(
                controller: _confirmPasswordController,
                hintText: l10n.confirmPasswordHint,
                obscureText: _obscureConfirmPassword,
                readOnly: false,
                suffix: AuthPasswordVisibilityToggle(
                  obscureText: _obscureConfirmPassword,
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  final base = Validators.required(
                    value,
                    requiredMessage: l10n.fieldRequired(
                      l10n.fieldConfirmPassword,
                    ),
                  );
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
              Center(
                child: AuthOutlinePillButton(
                  label: l10n.createMyAccount,
                  isLoading: isLoading,
                  width: 250,
                  onPressed: isLoading ? null : _submit,
                ),
              ),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }
}
