import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';

import '../../data/models/payment_method_model.dart';
import '../providers/payment_provider.dart';
import '../widgets/gift_card_tile.dart';
import '../widgets/payment_method_card.dart';

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
            child: PaymentMethodCard(
              method: method,
              isDeleting: _deletingPaymentMethodId == method.id,
              isSettingDefault: _defaultingPaymentMethodId == method.id,
              onSetDefault: () => _setDefaultMethod(ref, method),
              onModify: _showModifyHint,
              onDelete: _deletingPaymentMethodId == method.id
                  ? null
                  : () => _deletePaymentMethod(ref, method),
            ),
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
        if (state.giftCard != null) GiftCardTile(giftCard: state.giftCard!),
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
            style: AppTextStyles.heading.copyWith(
              color: PartnerUiColors.brand,
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

  Future<void> _deletePaymentMethod(
    WidgetRef ref,
    PaymentMethodModel method,
  ) async {
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

  Future<void> _setDefaultMethod(
    WidgetRef ref,
    PaymentMethodModel method,
  ) async {
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

  void _showModifyHint() {
    _showSnackBar(AppLocalizations.of(context).paymentMethodsModifyHint);
  }
}
