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

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({required this.mode, this.initialEmail, super.key});

  static const String modeAccount = 'account';
  static const String modeReset = 'reset';

  final String mode;
  final String? initialEmail;

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _otpControllers.map((c) => c.text).join();

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final otp = _otp;

    if (otp.length != 6) {
      showAuthSnackBar(context, l10n.otpMust6Digits);
      return;
    }

    try {
      if (widget.mode == VerifyOtpScreen.modeAccount) {
        await ref
            .read(authActionProvider.notifier)
            .verifyAccount(email: email, otp: otp);

        if (!mounted) return;

        showAuthSnackBar(context, l10n.accountVerified, isError: false);
        context.go(RouteNames.login);
        return;
      }

      final token = await ref
          .read(authActionProvider.notifier)
          .verifyPasswordOtp(email: email, otp: otp);

      if (!mounted) return;

      if (token.isEmpty) {
        showAuthSnackBar(context, l10n.invalidOtpResponse);
        return;
      }

      context.go(
        '${RouteNames.resetPassword}?token=${Uri.encodeComponent(token)}&email=${Uri.encodeComponent(email)}',
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
    final isAccountMode = widget.mode == VerifyOtpScreen.modeAccount;

    return AuthScreenScaffold(
      isLoading: isLoading,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(
            isAccountMode ? RouteNames.login : RouteNames.forgotPassword,
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
              isAccountMode
                  ? l10n.verifyAccountOtpTitle
                  : l10n.verifyResetOtpTitle,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.a6DigitCodeHasBeenSentToYourEmail,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AuthUiColors.brand.withValues(alpha: 0.75),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            // Email field (hidden/readonly when prefilled)
            if (widget.initialEmail == null ||
                widget.initialEmail!.isEmpty) ...[
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
              const SizedBox(height: 24),
            ],
            // OTP boxes
            AuthFieldLabel(l10n.otpLabel),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 44,
                  height: 54,
                  child: TextFormField(
                    controller: _otpControllers[index],
                    focusNode: _otpFocusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AuthUiColors.brand,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFF5EDE0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AuthUiColors.brand,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AuthUiColors.brand,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AuthUiColors.brand,
                          width: 2.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty && index < 5) {
                        _otpFocusNodes[index + 1].requestFocus();
                      } else if (val.isEmpty && index > 0) {
                        _otpFocusNodes[index - 1].requestFocus();
                      }
                      setState(() {});
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 36),
            Center(
              child: AuthFilledPillButton(
                label: l10n.verifyOtp,
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
