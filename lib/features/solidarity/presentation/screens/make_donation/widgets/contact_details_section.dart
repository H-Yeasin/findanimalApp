import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'MY CONTACT DETAILS',
              style: TextStyle(
                color: primaryOrange,
                fontFamily: 'Impact',
                fontSize: 22,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 15),
          _inputLabel('First & last name *'),
          _textField(
            controller: nameController,
            hint: 'Enter my first & last name',
            onChanged: onNameChanged,
            validator: (val) => val!.isEmpty ? 'Name is required' : null,
          ),
          _inputLabel('Email *'),
          _textField(
            controller: emailController,
            hint: 'Enter my email',
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
          const SizedBox(height: 15),
          if (state.isCompanyDonation) ...[
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
      padding: const EdgeInsets.only(bottom: 6.0, top: 8.0, left: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: primaryOrange,
          fontFamily: 'Impact',
          fontSize: 13,
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
        style: const TextStyle(color: Color(0xFFF6E7D1), fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFFF6E7D1).withValues(alpha: 0.7),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: primaryOrange,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          errorStyle: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
