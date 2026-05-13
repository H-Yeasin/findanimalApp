import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
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
  bool _isAddingCard = false;
  String? _deletingPaymentMethodId;
  String? _defaultingPaymentMethodId;

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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
        _buildSectionHeader(context, ref, l10n.paymentMethodsCardsAndAccounts),
        const SizedBox(height: 15),
        if (state.paymentMethods.isEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: PartnerUiColors.brand.withValues(alpha: 0.16),
              ),
            ),
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
          (method) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _buildPaymentMethodCard(context, ref, method),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(
          context,
          ref,
          l10n.paymentMethodsSalesBenefits,
          showAdd: false,
        ),
        const SizedBox(height: 15),
        if (state.giftCard != null) _buildGiftCardTile(context, state.giftCard!),
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
          _isAddingCard
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
                  onPressed: () => _openAddCardSheet(ref),
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
    if (_isAddingCard) return;

    setState(() {
      _isAddingCard = true;
    });

    try {
      final setupIntent = await ref
          .read(paymentProvider.notifier)
          .createSetupIntent();

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Hesteka',
          customerId: setupIntent['customerId'] as String,
          customerEphemeralKeySecret:
              setupIntent['customerEphemeralKeySecret'] as String,
          setupIntentClientSecret: setupIntent['clientSecret'] as String,
          allowsDelayedPaymentMethods: false,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      await ref.read(paymentProvider.notifier).refresh();
      _showSnackBar('Card added successfully.');
    } on StripeException catch (error) {
      final message = error.error.localizedMessage;
      if (message != null &&
          message.isNotEmpty &&
          error.error.code != FailureCode.Canceled) {
        _showSnackBar(message);
      }
    } catch (_) {
      _showSnackBar('Unable to add card right now. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isAddingCard = false;
        });
      }
    }
  }

  Future<void> _deletePaymentMethod(WidgetRef ref, PaymentMethodModel method) async {
    if (_deletingPaymentMethodId != null) return;

    setState(() {
      _deletingPaymentMethodId = method.id;
    });

    try {
      await ref.read(paymentProvider.notifier).deletePaymentMethod(method.id);
      _showSnackBar('Payment method deleted.');
    } catch (error) {
      _showSnackBar(
        AppLocalizations.of(context).paymentMethodsDeleteError('$error'),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deletingPaymentMethodId = null;
        });
      }
    }
  }

  Future<void> _setDefaultMethod(WidgetRef ref, PaymentMethodModel method) async {
    if (_defaultingPaymentMethodId != null || method.isDefault) return;

    setState(() {
      _defaultingPaymentMethodId = method.id;
    });

    try {
      await ref.read(paymentProvider.notifier).setDefault(method.id);
      _showSnackBar('Default payment method updated.');
    } catch (_) {
      _showSnackBar('Unable to update default payment method.');
    } finally {
      if (mounted) {
        setState(() {
          _defaultingPaymentMethodId = null;
        });
      }
    }
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    WidgetRef ref,
    PaymentMethodModel method,
  ) {
    final l10n = AppLocalizations.of(context);
    final isDeleting = _deletingPaymentMethodId == method.id;
    final isSettingDefault = _defaultingPaymentMethodId == method.id;

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
                _buildCardIcon(method.brand),
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
                        _setDefaultMethod(ref, method);
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    l10n.paymentMethodsModify,
                    _showModifyHint,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    isDeleting ? 'Deleting...' : l10n.paymentMethodsDelete,
                    isDeleting ? null : () => _deletePaymentMethod(ref, method),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showModifyHint() {
    _showSnackBar(AppLocalizations.of(context).paymentMethodsModifyHint);
  }

  Widget _buildGiftCardTile(BuildContext context, dynamic giftCard) {
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
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildActionButton(l10n.paymentMethodsTopUpBalance, null),
              const SizedBox(height: 5),
              _buildActionButton(l10n.paymentMethodsBuy, null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardIcon(String brand) {
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

  Widget _buildActionButton(String label, VoidCallback? onTap) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PartnerUiColors.brand,
          disabledBackgroundColor: PartnerUiColors.brand.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white70,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(fontSize: 12),
        ),
      ),
    );
  }
}
