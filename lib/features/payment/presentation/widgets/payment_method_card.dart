import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import 'package:hesteka_frontend/features/payment/data/models/payment_method_model.dart';
import 'payment_action_button.dart';
import 'payment_card_icon.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isDeleting;
  final bool isSettingDefault;
  final VoidCallback onSetDefault;
  final VoidCallback onModify;
  final VoidCallback? onDelete;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isDeleting,
    required this.isSettingDefault,
    required this.onSetDefault,
    required this.onModify,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isDeleting ? 0.55 : 1,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: method.isDefault
                ? PartnerUiColors.brand.withValues(alpha: 0.38)
                : PartnerUiColors.brand.withValues(alpha: 0.14),
            width: method.isDefault ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentCardIcon(brand: method.brand),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '${method.brandName} •••• ${method.last4}',
                            style: AppTextStyles.body.copyWith(
                              color: PartnerUiColors.brand,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (method.isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: PartnerUiColors.brand.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Default',
                                style: AppTextStyles.body.copyWith(
                                  color: PartnerUiColors.brand,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        [
                          if ((method.cardholderName ?? '').trim().isNotEmpty)
                            method.cardholderName!.trim(),
                          'Expires ${method.expiryDate}',
                        ].join(' • '),
                        style: AppTextStyles.body.copyWith(
                          color: PartnerUiColors.brand.withValues(alpha: 0.78),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.paymentMethodsUseAsDefault,
                    style: AppTextStyles.body.copyWith(
                      color: PartnerUiColors.brand,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (isSettingDefault)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        PartnerUiColors.brand,
                      ),
                    ),
                  )
                else
                  PartnerToggle(
                    value: method.isDefault,
                    onChanged: (val) {
                      if (val) {
                        onSetDefault();
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: PaymentActionButton(
                    label: l10n.paymentMethodsModify,
                    onTap: onModify,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PaymentActionButton(
                    label: isDeleting
                        ? 'Deleting...'
                        : l10n.paymentMethodsDelete,
                    onTap: onDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
