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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({
    this.initialEmail,
    this.lockEmail = false,
    super.key,
  });

  final String? initialEmail;
  final bool lockEmail;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    try {
      await ref.read(authActionProvider.notifier).forgetPassword(email: email);

      if (!mounted) return;

      showAuthSnackBar(context, l10n.otpSent, isError: false);

      context.go(
        '${RouteNames.verifyOtp}?mode=reset&email=${Uri.encodeComponent(email)}',
      );
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
            AuthMainTitle(l10n.forgotPasswordTitle),
            const SizedBox(height: 12),
            Text(
              l10n.enterYourEmailAddressToResetPassword,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AuthUiColors.brand.withValues(alpha: 0.75),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            AuthFieldLabel(l10n.emailLabel),
            const SizedBox(height: 8),
            AuthPillTextField(
              controller: _emailController,
              hintText: l10n.emailHint,
              keyboardType: TextInputType.emailAddress,
              readOnly: widget.lockEmail,
              suffix: widget.lockEmail
                  ? const Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: AuthUiColors.brand,
                    )
                  : null,
              validator: (value) => Validators.email(
                value,
                requiredMessage: l10n.emailRequired,
                invalidMessage: l10n.emailInvalid,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: AuthFilledPillButton(
                label: l10n.sendOtp,
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
