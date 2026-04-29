import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _inputLabel('Payment Method *'),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onMethodChanged('stripe'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: state.paymentMethod == 'stripe'
                          ? primaryOrange
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryOrange),
                    ),
                    child: Center(
                      child: Text(
                        'Credit Card (Stripe)',
                        style: TextStyle(
                          color: state.paymentMethod == 'stripe'
                              ? Colors.white
                              : primaryOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => onMethodChanged('paypal'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: state.paymentMethod == 'paypal'
                          ? const Color(0xFFFFC439)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFC439)),
                    ),
                    child: Center(
                      child: Text(
                        'PayPal',
                        style: TextStyle(
                          color: state.paymentMethod == 'paypal'
                              ? const Color(0xFF003087)
                              : Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
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
}
