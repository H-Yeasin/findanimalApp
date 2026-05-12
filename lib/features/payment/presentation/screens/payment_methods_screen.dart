import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';

import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/payment_method_model.dart';
import '../providers/payment_provider.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

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
    final l10n = AppLocalizations.of(context);

    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: l10n.paymentMethodsHeroTitle,
        imageUrl: AppAssets.myPaymentsHeader,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: paymentState.when(
          data: (state) => _buildContent(context, ref, state),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text(l10n.errorLoadingFailed)),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    PaymentState state,
  ) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          ref,
          l10n.paymentMethodsCardsAndAccounts,
        ),
        const SizedBox(height: 15),
        if (state.paymentMethods.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              l10n.paymentMethodsNoSavedCards,
              style: AppTextStyles.body.copyWith(
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
        _buildSectionHeader(
          context,
          ref,
          l10n.paymentMethodsSalesBenefits,
          showAdd: false,
        ),
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
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
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
                  child: Text(
                    l10n.paymentMethodsAddNew,
                    style: AppTextStyles.body.copyWith(
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
      SnackBar(
        content: Text(
          AppLocalizations.of(context).paymentMethodsSystemDisabled,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    WidgetRef ref,
    PaymentMethodModel method,
  ) {
    final l10n = AppLocalizations.of(context);

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
                      style: AppTextStyles.body.copyWith(
                        color: PartnerUiColors.brand,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${method.cardholderName} - ${method.expiryDate}',
                      style: AppTextStyles.body.copyWith(
                        color: PartnerUiColors.brand,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildActionButton(l10n.paymentMethodsModify, () {
                    // Stripe doesn't easily allow modifying card details once saved.
                    // Usually you delete and re-add.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.paymentMethodsModifyHint,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 5),
                  _buildActionButton(l10n.paymentMethodsDelete, () async {
                    try {
                      await ref
                          .read(paymentProvider.notifier)
                          .deletePaymentMethod(method.id);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.paymentMethodsDeleteError('$e'),
                            ),
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
              Expanded(
                child: Text(
                  l10n.paymentMethodsUseAsDefault,
                  style: AppTextStyles.body.copyWith(
                    color: PartnerUiColors.brand,
                    fontSize: 13,
                  ),
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
    final l10n = AppLocalizations.of(context);

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
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            _buildActionButton(l10n.paymentMethodsTopUpBalance, () {}),
            const SizedBox(height: 5),
            _buildActionButton(l10n.paymentMethodsBuy, () {}),
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
        child: Text(label, style: AppTextStyles.body.copyWith(fontSize: 12)),
      ),
    );
  }
}
