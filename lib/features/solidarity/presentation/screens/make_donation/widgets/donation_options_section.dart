import 'package:flutter/material.dart';

import '../../../providers/donation_provider.dart';

class DonationOptionsSection extends StatelessWidget {
  const DonationOptionsSection({
    super.key,
    required this.state,
    required this.primaryOrange,
    required this.amountController,
    required this.onTypeChanged,
    required this.onAmountSelected,
    required this.onCustomAmountChanged,
  });

  final DonationState state;
  final Color primaryOrange;
  final TextEditingController amountController;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<double> onAmountSelected;
  final ValueChanged<String> onCustomAmountChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'MY\nDONATION',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFBA4A22),
              fontFamily: 'EricaOne',
              fontSize: 26,
              letterSpacing: 1.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6E7D1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryOrange),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _typeButton(
                        title: 'ONE-TIME\nDONATION',
                        value: 'one-time',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _typeButton(
                        title: 'MONTHLY\nDONATION',
                        value: 'monthly',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _amountButton(5.0)),
                    const SizedBox(width: 10),
                    Expanded(child: _amountButton(10.0)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _amountButton(20.0)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: primaryOrange,
                          fontFamily: 'EricaOne',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: TextStyle(
                            color: primaryOrange.withValues(alpha: 0.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: primaryOrange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: primaryOrange,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: onCustomAmountChanged,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeButton({required String title, required String value}) {
    final isSelected = value == state.type;
    return GestureDetector(
      onTap: () => onTypeChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: primaryOrange),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : primaryOrange,
              fontFamily: 'EricaOne',
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _amountButton(double amount) {
    final isSelected = amount == state.amount;
    return GestureDetector(
      onTap: () => onAmountSelected(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: primaryOrange),
        ),
        child: Center(
          child: Text(
            '${amount.toInt()}€',
            style: TextStyle(
              color: isSelected ? Colors.white : primaryOrange,
              fontFamily: 'EricaOne',
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
