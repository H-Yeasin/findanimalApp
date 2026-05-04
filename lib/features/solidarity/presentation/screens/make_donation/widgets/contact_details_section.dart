import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import '../../../providers/donation_provider.dart';

class ContactDetailsSection extends StatelessWidget {
  const ContactDetailsSection({
    super.key,
    required this.state,
    required this.primaryOrange,
    required this.nameController,
    required this.emailController,
    required this.companyNameController,
    required this.companySirenController,
    required this.companyLegalFormController,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onToggleCompanyDonation,
    required this.onCompanyNameChanged,
    required this.onCompanySirenChanged,
    required this.onCompanyLegalFormChanged,
  });

  final DonationState state;
  final Color primaryOrange;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController companyNameController;
  final TextEditingController companySirenController;
  final TextEditingController companyLegalFormController;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onToggleCompanyDonation;
  final ValueChanged<String> onCompanyNameChanged;
  final ValueChanged<String> onCompanySirenChanged;
  final ValueChanged<String> onCompanyLegalFormChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              l10n.myDetails,
              style: AppTextStyles.condensedSectionTitle.copyWith(
                fontSize: 27,
                color: primaryOrange,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // PayPal Button Placeholder
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFC439), // PayPal Yellow
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/payment/paypal_logo.png', // Assuming this exists or using a generic icon
                height: 30,
                errorBuilder: (context, error, stackTrace) => const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Color(0xFF003087)),
                    SizedBox(width: 5),
                    Text(
                      'PayPal',
                      style: TextStyle(
                        color: Color(0xFF003087),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Expanded(child: Divider(thickness: 1.5)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  l10n.orEnterDetails,
                  style: TextStyle(
                    color: primaryOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(child: Divider(thickness: 1.5)),
            ],
          ),
          const SizedBox(height: 20),
          _inputLabel(l10n.emailLabel),
          _textField(
            controller: emailController,
            hint: l10n.emailHint,
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
            validator: (val) {
              final email = (val ?? '').trim();
              if (email.isEmpty) return 'Email is required';
              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
              if (!emailRegex.hasMatch(email)) return 'Invalid email';
              return null;
            },
          ),
          _inputLabel('${l10n.nameAndFirstName}*'),
          _textField(
            controller: nameController,
            hint: l10n.enterMyFirstAndLastName,
            onChanged: onNameChanged,
            validator: (val) => val!.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onToggleCompanyDonation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2, right: 10),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: state.isCompanyDonation
                        ? primaryOrange
                        : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: primaryOrange),
                  ),
                  child: state.isCompanyDonation
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                Expanded(
                  child: Text(
                    'I am making a donation on behalf of a company, a liberal\nprofession, or an association',
                    style: TextStyle(
                      color: primaryOrange,
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state.isCompanyDonation) ...[
            const SizedBox(height: 15),
            _textField(
              controller: companyNameController,
              hint: 'Company name',
              onChanged: onCompanyNameChanged,
              validator: (val) =>
                  val!.isEmpty ? 'Company name is required' : null,
            ),
            _textField(
              controller: companySirenController,
              hint: 'SIREN',
              onChanged: onCompanySirenChanged,
            ),
            _textField(
              controller: companyLegalFormController,
              hint: 'Legal form',
              onChanged: onCompanyLegalFormChanged,
            ),
          ],
        ],
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 4.0, left: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: primaryOrange,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          filled: true,
          fillColor: primaryOrange,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          errorStyle: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
