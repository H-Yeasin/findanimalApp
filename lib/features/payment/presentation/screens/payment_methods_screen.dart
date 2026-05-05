import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/payment_method_model.dart';
import '../providers/payment_provider.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);

    return PartnerScreenScaffold(
      header: const PartnerHeroHeader(
        title: 'MY PAYMENT\nMEANS',
        imageUrl: "assets/mypaymentsHeader.png",
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: paymentState.when(
          data: (state) => _buildContent(context, ref, state),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    PaymentState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, ref, 'Cards and accounts'),
        const SizedBox(height: 15),
        if (state.paymentMethods.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'No saved cards yet. Tap + Add new to store one.',
              style: TextStyle(
                color: PartnerUiColors.brand,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ...state.paymentMethods.map(
          (method) => _buildPaymentMethodCard(context, ref, method),
        ),
        const SizedBox(height: 30),
        _buildSectionHeader(context, ref, 'Sales & benefits', showAdd: false),
        const SizedBox(height: 15),
        if (state.giftCard != null)
          _buildGiftCardTile(context, state.giftCard!),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    WidgetRef ref,
    String title, {
    bool showAdd = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: PartnerUiColors.brand,
              fontFamily: 'EricaOne',
              fontSize: 24,
            ),
          ),
        ),
        if (showAdd)
          _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      PartnerUiColors.brand,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _isLoading ? null : () => _openAddCardSheet(ref),
                  child: const Text(
                    '+ Add new',
                    style: TextStyle(
                      color: PartnerUiColors.brand,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
      ],
    );
  }

  Future<void> _openAddCardSheet(WidgetRef ref) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment system is currently disabled.')),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    WidgetRef ref,
    PaymentMethodModel method,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardIcon(method.type),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${method.brandName} ••••${method.lastFour}',
                      style: const TextStyle(
                        color: PartnerUiColors.brand,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${method.cardholderName} - ${method.expiryDate}',
                      style: const TextStyle(
                        color: PartnerUiColors.brand,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildActionButton('To modify', () {
                    // Stripe doesn't easily allow modifying card details once saved.
                    // Usually you delete and re-add.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'To modify card details, please delete and add a new one.',
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 5),
                  _buildActionButton('DELETE', () async {
                    try {
                      await ref
                          .read(paymentProvider.notifier)
                          .deletePaymentMethod(method.id);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting payment method: $e'),
                          ),
                        );
                      }
                    }
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Use as default payment method',
                  style: TextStyle(color: PartnerUiColors.brand, fontSize: 13),
                ),
              ),
              PartnerToggle(
                value: method.isDefault,
                onChanged: (val) {
                  if (val) {
                    ref.read(paymentProvider.notifier).setDefault(method.id);
                  }
                },
              ),
            ],
          ),
          const Divider(color: PartnerUiColors.brand, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildGiftCardTile(BuildContext context, dynamic giftCard) {
    return Row(
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
              const Text(
                'Hesteka gift card',
                style: TextStyle(
                  color: PartnerUiColors.brand,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${giftCard.formattedBalance} available',
                style: const TextStyle(
                  color: PartnerUiColors.brand,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            _buildActionButton('Top up balance', () {}),
            const SizedBox(height: 5),
            _buildActionButton('Buy', () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildCardIcon(AppPaymentMethodType type) {
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue.shade800, // Replace with actual card images
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          type == AppPaymentMethodType.visa ? Icons.credit_card : Icons.payment,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: 120,
      height: 28,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PartnerUiColors.brand,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
