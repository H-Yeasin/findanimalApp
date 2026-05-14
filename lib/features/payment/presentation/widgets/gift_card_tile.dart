import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import 'payment_action_button.dart';

class GiftCardTile extends StatelessWidget {
  final dynamic giftCard;

  const GiftCardTile({
    super.key,
    required this.giftCard,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: PartnerUiColors.brand.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              color: PartnerUiColors.brand,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.volunteer_activism_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.paymentMethodsGiftCardTitle,
                  style: AppTextStyles.body.copyWith(
                    color: PartnerUiColors.brand,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  l10n.paymentMethodsBalanceAvailable(
                    giftCard.formattedBalance.toString(),
                  ),
                  style: AppTextStyles.body.copyWith(
                    color: PartnerUiColors.brand,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              PaymentActionButton(label: l10n.paymentMethodsTopUpBalance, onTap: null),
              const SizedBox(height: 5),
              PaymentActionButton(label: l10n.paymentMethodsBuy, onTap: null),
            ],
          ),
        ],
      ),
    );
  }
}
