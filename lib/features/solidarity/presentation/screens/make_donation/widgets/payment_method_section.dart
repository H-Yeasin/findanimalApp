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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'You will be securely redirected to Stripe to enter your card details.',
              style: AppTextStyles.body.copyWith(
                color: primaryOrange.withValues(alpha: 0.8),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (state.error != null) ...[
            const SizedBox(height: 10),
            Text(
              state.error!,
              style: AppTextStyles.body.copyWith(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
