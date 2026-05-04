import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import '../../../providers/donation_provider.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({
    super.key,
    required this.state,
    required this.primaryOrange,
    required this.onMethodChanged,
  });

  final DonationState state;
  final Color primaryOrange;
  final ValueChanged<String> onMethodChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text(
            l10n.payment,
            style: AppTextStyles.condensedSectionTitle.copyWith(
              fontSize: 27,
              color: primaryOrange,
            ),
          ),
          const SizedBox(height: 15),
          _inputLabel(l10n.cardNumber),
          _textField(
            hint: '1234 1234 1234 1234',
            keyboardType: TextInputType.number,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inputLabel(l10n.expiryDate),
                    _textField(
                      hint: 'MM / AA',
                      keyboardType: TextInputType.datetime,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inputLabel('CCV'),
                    _textField(hint: 'CCV', keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),
          if (state.error != null) ...[
            const SizedBox(height: 10),
            Text(
              state.error!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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

  Widget _textField({required String hint, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        keyboardType: keyboardType,
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
        ),
      ),
    );
  }
}
