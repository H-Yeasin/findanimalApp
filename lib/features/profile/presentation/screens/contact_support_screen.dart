import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import '../providers/profile_providers.dart';

class ContactSupportScreen extends ConsumerStatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  ConsumerState<ContactSupportScreen> createState() =>
      _ContactSupportScreenState();
}

class _ContactSupportScreenState extends ConsumerState<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(contactSupportProvider.notifier)
          .submitMessage(
            email: _emailController.text,
            name: _nameController.text,
            subject: _subjectController.text,
            message: _messageController.text,
          );

      if (mounted) {
        final state = ref.read(contactSupportProvider);
        if (state.hasError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error.toString())));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).messageSentSuccessfully,
              ),
            ),
          );
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final submissionState = ref.watch(contactSupportProvider);

    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: l10n.contactUs,
        imageUrl: AppAssets.contactUs,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildContactOption(Icons.phone, '06 41 45 83 60'),
                    const SizedBox(width: 8),
                    _buildContactOption(Icons.email, 'contact@hesteka.com'),
                    const SizedBox(width: 8),
                    _buildContactOption(Icons.language, 'www.hesteka.com'),
                    const SizedBox(width: 8),
                    _buildContactOption(Icons.camera_alt, '@_hesteka...'),
                    const SizedBox(width: 8),
                    _buildContactOption(Icons.facebook, 'HESTEKA'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildFieldLabel(l10n.fieldEmail),
              _buildInputField(
                l10n.emailHint,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.emailRequired;
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return l10n.emailInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildFieldLabel(l10n.nameAndFirstName),
              _buildInputField(
                l10n.enterMyFirstAndLastName,
                controller: _nameController,
                validator: (value) => (value == null || value.isEmpty)
                    ? l10n.sfieldRequired
                    : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel(l10n.subject),
              _buildInputField(
                l10n.contactSubjectHint,
                controller: _subjectController,
                validator: (value) => (value == null || value.isEmpty)
                    ? l10n.sfieldRequired
                    : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel(l10n.message),
              _buildInputField(
                l10n.tellUsEverything,
                controller: _messageController,
                maxLines: 5,
                validator: (value) => (value == null || value.isEmpty)
                    ? l10n.sfieldRequired
                    : null,
              ),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 280,
                  height: 40,
                  child: OutlinedButton(
                    onPressed: submissionState.isLoading ? null : _submit,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: PartnerUiColors.brand),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: submissionState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: PartnerUiColors.brand,
                            ),
                          )
                        : Text(
                            l10n.sendMyMessage,
                            style: AppTextStyles.body.copyWith(
                              color: PartnerUiColors.brand,
                              fontFamily: 'EricaOne',
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: PartnerUiColors.brand,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(
          color: PartnerUiColors.brand,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildInputField(
    String hint, {
    int maxLines = 1,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 12,
        ),
        fillColor: PartnerUiColors.brand,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(height: 0),
      ),
    );
  }
}
