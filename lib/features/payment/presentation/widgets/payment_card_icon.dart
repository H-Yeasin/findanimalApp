import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';

class PaymentCardIcon extends StatelessWidget {
  final String brand;

  const PaymentCardIcon({
    super.key,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = brand.toLowerCase();
    final backgroundColor = switch (normalized) {
      'visa' => const Color(0xFF1434CB),
      'mastercard' => const Color(0xFFEB001B),
      'amex' || 'american_express' => const Color(0xFF2E77BB),
      'discover' => const Color(0xFFFF6F00),
      'unionpay' => const Color(0xFF008561),
      _ => PartnerUiColors.brand,
    };
    final label = switch (normalized) {
      'visa' => 'VISA',
      'mastercard' => 'MC',
      'amex' || 'american_express' => 'AMEX',
      'discover' => 'DISC',
      'unionpay' => 'UP',
      _ => 'CARD',
    };

    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
