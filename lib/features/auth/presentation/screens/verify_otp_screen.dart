import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

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
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();

    try {
      if (widget.mode == VerifyOtpScreen.modeAccount) {
        await ref
            .read(authActionProvider.notifier)
            .verifyAccount(email: email, otp: otp);

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.accountVerified)));
        context.go(RouteNames.login);
        return;
      }

      final token = await ref
          .read(authActionProvider.notifier)
          .verifyPasswordOtp(email: email, otp: otp);

      if (!mounted) {
        return;
      }

      if (token.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.invalidOtpResponse)));
        return;
      }

      context.go(
        '${RouteNames.resetPassword}?token=${Uri.encodeComponent(token)}&email=${Uri.encodeComponent(email)}',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authErrorMessage(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authActionProvider).isLoading;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == VerifyOtpScreen.modeAccount
              ? l10n.verifyAccountOtpTitle
              : l10n.verifyResetOtpTitle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: l10n.fieldEmail),
                  validator: (value) => Validators.email(
                    value,
                    requiredMessage: l10n.emailRequired,
                    invalidMessage: l10n.emailInvalid,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(labelText: l10n.otpLabel),
                  validator: (value) {
                    final base = Validators.required(
                      value,
                      requiredMessage: l10n.fieldRequired(l10n.fieldOtp),
                    );
                    if (base != null) {
                      return base;
                    }
                    if (value!.trim().length != 6) {
                      return l10n.otpMust6Digits;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: l10n.verifyOtp,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
