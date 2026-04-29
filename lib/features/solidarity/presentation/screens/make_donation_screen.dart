import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import '../providers/donation_provider.dart';
import 'make_donation/make_donation_styles.dart';
import 'make_donation/widgets/confirm_donation_button.dart';
import 'make_donation/widgets/contact_details_section.dart';
import 'make_donation/widgets/donation_options_section.dart';
import 'make_donation/widgets/make_donation_header.dart';
import 'make_donation/widgets/payment_method_section.dart';



class MakeDonationScreen extends ConsumerStatefulWidget {
  const MakeDonationScreen({super.key});

  @override
  ConsumerState<MakeDonationScreen> createState() => _MakeDonationScreenState();
}

class _MakeDonationScreenState extends ConsumerState<MakeDonationScreen>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companySirenController = TextEditingController();
  final _companyLegalFormController = TextEditingController();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _deepLinkSub;

  String? _pendingPayPalOrderId;
  bool _awaitingPayPalReturn = false;
  bool _isCapturingPayPal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenToDeepLinks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _deepLinkSub?.cancel();
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _companySirenController.dispose();
    _companyLegalFormController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _awaitingPayPalReturn &&
        _pendingPayPalOrderId != null &&
        !_isCapturingPayPal) {
      _capturePayPalOrder(
        _pendingPayPalOrderId!,
        source: 'app resumed after PayPal',
      );
    }
  }

  void _listenToDeepLinks() {
    _deepLinkSub = _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint('[PayPalFlow] deep link received: $uri');
        _handleDeepLink(uri);
      },
      onError: (error) {
        debugPrint('[PayPalFlow] deep link stream error: $error');
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    if (uri.scheme != 'hesteka') return;

    final host = uri.host.toLowerCase();
    if (host == 'paypal-success') {
      final orderId = uri.queryParameters['orderId'] ?? _pendingPayPalOrderId;
      if (orderId == null || orderId.isEmpty) {
        _showSnackBar('Could not detect PayPal order id.');
        return;
      }
      _capturePayPalOrder(orderId, source: 'deep link success');
      return;
    }

    if (host == 'paypal-cancel') {
      _awaitingPayPalReturn = false;
      _pendingPayPalOrderId = null;
      _showSnackBar('PayPal payment was cancelled.');
      return;
    }
  }

  Future<void> _capturePayPalOrder(
    String orderId, {
    required String source,
  }) async {
    if (_isCapturingPayPal) return;

    _isCapturingPayPal = true;
    debugPrint(
      '[PayPalFlow] capture started from $source with orderId=$orderId',
    );

    try {
      final success = await ref
          .read(donationNotifierProvider.notifier)
          .capturePayPal(orderId);
      if (!mounted) return;

      if (success) {
        _awaitingPayPalReturn = false;
        _pendingPayPalOrderId = null;
        ref.invalidate(myDonationsProvider);
        _showSnackBar('PayPal donation completed successfully.');
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      } else {
        final error = ref.read(donationNotifierProvider).error;
        _showSnackBar(
          error?.isNotEmpty == true
              ? error!
              : 'PayPal capture failed. Please try again.',
        );
      }
    } finally {
      _isCapturingPayPal = false;
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onConfirm() async {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(donationNotifierProvider);
    if (state.amount <= 0) {
      _showSnackBar('Please select or enter an amount');
      return;
    }
    if (state.paymentMethod.isEmpty) {
      _showSnackBar('Please select a payment method');
      return;
    }

    final notifier = ref.read(donationNotifierProvider.notifier);

    if (state.paymentMethod == 'stripe') {
      await _handleStripePayment(state, notifier);
      return;
    }

    if (state.paymentMethod == 'paypal') {
      await _handlePayPalPayment(notifier);
    }
  }

  Future<void> _handleStripePayment(DonationState state, DonationNotifier notifier) async {
    _showSnackBar("Card payments are currently disabled.");
  }

    Future<void> _handlePayPalPayment(DonationNotifier notifier) async {
    final result = await notifier.initiatePayPal();
    if (!mounted) return;

    if (result == null) {
      final error = ref.read(donationNotifierProvider).error;
      _showSnackBar(
        error?.isNotEmpty == true
            ? error!
            : 'Could not start PayPal payment. Please try again.',
      );
      return;
    }

    final approvalUrl = result['approvalUrl'] as String?;
    final orderId = result['orderId'] as String?;
    if (approvalUrl == null ||
        approvalUrl.isEmpty ||
        orderId == null ||
        orderId.isEmpty) {
      _showSnackBar('Failed to get PayPal checkout details.');
      return;
    }

    _pendingPayPalOrderId = orderId;
    _awaitingPayPalReturn = true;

    final url = Uri.parse(approvalUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      _showSnackBar(
        'Complete PayPal in browser. We will finish capture when you return.',
      );
    } else {
      _showSnackBar('Could not launch PayPal checkout.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(donationNotifierProvider);

    return Scaffold(
      backgroundColor: makeDonationBackgroundColor,
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: makeDonationPrimaryOrange,
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    MakeDonationHeader(
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    DonationOptionsSection(
                      state: state,
                      primaryOrange: makeDonationPrimaryOrange,
                      amountController: _amountController,
                      onTypeChanged: (type) {
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updateType(type);
                      },
                      onAmountSelected: (amount) {
                        _amountController.clear();
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updateAmount(amount);
                      },
                      onCustomAmountChanged: (value) {
                        final amount = double.tryParse(value) ?? 0.0;
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updateAmount(amount);
                      },
                    ),
                    ContactDetailsSection(
                      state: state,
                      primaryOrange: makeDonationPrimaryOrange,
                      nameController: _nameController,
                      emailController: _emailController,
                      companyNameController: _companyNameController,
                      companySirenController: _companySirenController,
                      companyLegalFormController: _companyLegalFormController,
                      onNameChanged: (name) {
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updateDonorInfo(name: name.trim());
                      },
                      onEmailChanged: (email) {
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updateDonorInfo(email: email.trim());
                      },
                      onToggleCompanyDonation: () {
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updateCompanyInfo(
                              isCompany: !state.isCompanyDonation,
                            );
                      },
                      onCompanyNameChanged: (name) {
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updateCompanyInfo(name: name);
                      },
                      onCompanySirenChanged: (siren) {
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updateCompanyInfo(siren: siren);
                      },
                      onCompanyLegalFormChanged: (legalForm) {
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updateCompanyInfo(legalForm: legalForm);
                      },
                    ),
                    PaymentMethodSection(
                      state: state,
                      primaryOrange: makeDonationPrimaryOrange,
                      onMethodChanged: (method) {
                        ref
                            .read(donationNotifierProvider.notifier)
                            .updatePaymentMethod(method);
                      },
                    ),
                    const SizedBox(height: 20),
                    ConfirmDonationButton(
                      primaryOrange: makeDonationPrimaryOrange,
                      onTap: _onConfirm,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}
