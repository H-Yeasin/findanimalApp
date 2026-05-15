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

class AuthLoginScreen extends ConsumerStatefulWidget {
  const AuthLoginScreen({super.key, this.isPartner = false});

  final bool isPartner;

  @override
  ConsumerState<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends ConsumerState<AuthLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(authSessionProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      // Navigation is now handled by ref.listen in the build method
    } catch (error) {
      if (!mounted) {
        return;
      }
      showAuthSnackBar(context, authErrorMessage(error, l10n), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authSessionProvider, (previous, next) {
      next.whenData((session) {
        if (session.status == AuthStatus.authenticated && mounted) {
          final l10n = AppLocalizations.of(context);
          final user = session.user;

          if (widget.isPartner && user?.role != 'partners') {
            ref.read(authSessionProvider.notifier).logout();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.unauthorizedPartnerLogin),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (user?.role == 'partners') {
            context.go(RouteNames.partnerAccess);
          } else {
            context.go(RouteNames.myProfile);
          }
        }
      });
    });

    final isLoading = ref.watch(authSessionProvider).isLoading;
    final l10n = AppLocalizations.of(context);

    return AuthScreenScaffold(
      isLoading: isLoading,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(
            widget.isPartner
                ? RouteNames.partnerAuthGateway
                : RouteNames.account,
          );
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
            AuthMainTitle(
              widget.isPartner ? l10n.partnerLoginTitle : l10n.loginTitle,
            ),
            const SizedBox(height: 30),
            AuthFieldLabel(l10n.emailLabel),
            const SizedBox(height: 8),
            AuthPillTextField(
              controller: _emailController,
              hintText: l10n.emailHint,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.email(
                value,
                requiredMessage: l10n.emailRequired,
                invalidMessage: l10n.emailInvalid,
              ),
              readOnly: false,
            ),
            const SizedBox(height: 10),
            AuthFieldLabel(l10n.passwordLabel),
            const SizedBox(height: 8),
            AuthPillTextField(
              controller: _passwordController,
              hintText: l10n.passwordHint,
              obscureText: _obscurePassword,
              validator: (value) => Validators.required(
                value,
                requiredMessage: l10n.fieldRequired(l10n.fieldPassword),
              ),
              suffix: AuthPasswordVisibilityToggle(
                obscureText: _obscurePassword,
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              readOnly: false,
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => context.push(RouteNames.forgotPassword),
                child: Text(
                  l10n.forgotPassword,
                  style: AppTextStyles.body.copyWith(
                    color: AuthUiColors.brand,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    decorationColor: AuthUiColors.brand,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: AuthOutlinePillButton(
                label: l10n.continueLabel,
                isLoading: isLoading,
                width: 150,
                onPressed: isLoading ? null : _submit,
              ),
            ),
            if (!widget.isPartner) ...[
              const SizedBox(height: 32),
              AuthSocialPillButton(
                leading: const Icon(Icons.apple, color: Colors.white, size: 20),
                label: l10n.continueWithApple,
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              AuthSocialPillButton(
                leading: const AuthGoogleGlyph(),
                label: l10n.continueWithGoogle,
                onPressed: () {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}
