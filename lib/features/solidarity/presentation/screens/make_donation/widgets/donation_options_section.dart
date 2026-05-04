import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
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
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          Text(
            l10n.mySupport,
            textAlign: TextAlign.center,
            style: AppTextStyles.condensedSectionTitle.copyWith(
              fontSize: 27,
              color: primaryOrange,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF4E9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryOrange.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _typeButton(
                        title: l10n.oneTimeSupport,
                        value: 'one-time',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _typeButton(
                        title: l10n.monthlySupport,
                        value: 'monthly',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _amountButton(5.0)),
                    const SizedBox(width: 15),
                    Expanded(child: _amountButton(10.0)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _amountButton(20.0)),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Trigger custom amount entry logic if needed
                          // For now, we just let the user type in the field
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: primaryOrange),
                          ),
                          child: Center(
                            child: Text(
                              l10n.enterAmount,
                              style: TextStyle(
                                color: primaryOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
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
              fontWeight: FontWeight.w900,
              fontSize: 11,
              height: 1.0,
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
        padding: const EdgeInsets.symmetric(vertical: 12),
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
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
