import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_ui_kit.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({required this.token, this.email, super.key});

  final String token;
  final String? email;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;

    try {
      await ref
          .read(authActionProvider.notifier)
          .resetPassword(
            token: widget.token,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );

      if (!mounted) return;

      showAuthSnackBar(context, l10n.passwordResetSuccess, isError: false);
      context.go(RouteNames.login);
    } catch (error) {
      if (!mounted) return;
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
          context.go(RouteNames.login);
        }
      },
      onBottomTap: (_) => context.go(RouteNames.root),
      contentPadding: const EdgeInsets.fromLTRB(34, 20, 34, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 6),
            AuthMainTitle(l10n.resetPasswordTitle),
            const SizedBox(height: 12),
            if (widget.email != null && widget.email!.isNotEmpty) ...[
              Text(
                '${l10n.resettingPasswordFor}\n${widget.email}',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AuthUiColors.brand.withValues(alpha: 0.75),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
            ] else ...[
              const SizedBox(height: 30),
            ],
            AuthFieldLabel(l10n.newPasswordLabel),
            const SizedBox(height: 8),
            AuthPillTextField(
              controller: _passwordController,
              hintText: l10n.passwordHint,
              obscureText: _obscurePassword,
              readOnly: false,
              suffix: AuthPasswordVisibilityToggle(
                obscureText: _obscurePassword,
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) => Validators.required(
                value,
                requiredMessage: l10n.fieldRequired(l10n.newPasswordLabel),
              ),
            ),
            const SizedBox(height: 14),
            AuthFieldLabel(l10n.fieldConfirmPassword),
            const SizedBox(height: 8),
            AuthPillTextField(
              controller: _confirmPasswordController,
              hintText: l10n.confirmPasswordHint,
              readOnly: false,
              obscureText: _obscureConfirmPassword,
              suffix: AuthPasswordVisibilityToggle(
                obscureText: _obscureConfirmPassword,
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
              validator: (value) {
                final base = Validators.required(
                  value,
                  requiredMessage: l10n.fieldRequired(
                    l10n.fieldConfirmPassword,
                  ),
                );
                if (base != null) return base;
                if (value != _passwordController.text) {
                  return l10n.passwordsDoNotMatch;
                }
                return null;
              },
            ),
            const SizedBox(height: 36),
            Center(
              child: AuthFilledPillButton(
                label: l10n.updatePassword,
                isLoading: isLoading,
                onPressed: isLoading ? null : _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
