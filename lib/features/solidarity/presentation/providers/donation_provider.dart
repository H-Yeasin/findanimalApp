import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../data/repositories/donation_repository.dart';

class DonationState {
  final double amount;
  final String type; // "one-time" or "monthly"
  final String donorName;
  final String donorEmail;
  final bool isCompanyDonation;
  final String companyName;
  final String companySiren;
  final String companyLegalForm;
  final String paymentMethod; // "stripe" or "paypal"
  final bool isLoading;
  final String? error;

  const DonationState({
    this.amount = 0.0,
    this.type = 'one-time',
    this.donorName = '',
    this.donorEmail = '',
    this.isCompanyDonation = false,
    this.companyName = '',
    this.companySiren = '',
    this.companyLegalForm = '',
    this.paymentMethod = '',
    this.isLoading = false,
    this.error,
  });

  DonationState copyWith({
    double? amount,
    String? type,
    String? donorName,
    String? donorEmail,
    bool? isCompanyDonation,
    String? companyName,
    String? companySiren,
    String? companyLegalForm,
    String? paymentMethod,
    bool? isLoading,
    String? error,
  }) {
    return DonationState(
      amount: amount ?? this.amount,
      type: type ?? this.type,
      donorName: donorName ?? this.donorName,
      donorEmail: donorEmail ?? this.donorEmail,
      isCompanyDonation: isCompanyDonation ?? this.isCompanyDonation,
      companyName: companyName ?? this.companyName,
      companySiren: companySiren ?? this.companySiren,
      companyLegalForm: companyLegalForm ?? this.companyLegalForm,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  Map<String, dynamic> toPayload() {
    final payload = {
      'amount': amount,
      'currency': 'eur',
      'type': type,
      'donorName': donorName.trim(),
      'donorEmail': donorEmail.trim(),
      'isCompanyDonation': isCompanyDonation,
    };
    if (isCompanyDonation) {
      payload['companyInfo'] = {
        'name': companyName,
        'siren': companySiren,
        'legalForm': companyLegalForm,
      };
    }
    return payload;
  }
}

class DonationNotifier extends Notifier<DonationState> {
  @override
  DonationState build() {
    return const DonationState();
  }

  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void updateType(String type) {
    state = state.copyWith(type: type);
  }

  void updateDonorInfo({String? name, String? email}) {
    state = state.copyWith(
      donorName: name ?? state.donorName,
      donorEmail: email ?? state.donorEmail,
    );
  }

  void updateCompanyInfo({
    bool? isCompany,
    String? name,
    String? siren,
    String? legalForm,
  }) {
    state = state.copyWith(
      isCompanyDonation: isCompany ?? state.isCompanyDonation,
      companyName: name ?? state.companyName,
      companySiren: siren ?? state.companySiren,
      companyLegalForm: legalForm ?? state.companyLegalForm,
    );
  }

  void updatePaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<Map<String, dynamic>?> initiateStripe() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(donationRepositoryProvider);
      final result = await repo.initiateStripeDonation(state.toPayload());
      state = state.copyWith(isLoading: false);
      return result;
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: NetworkExceptions.fromDio(e),
      );
      return null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> initiatePayPal() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(donationRepositoryProvider);
      final result = await repo.initiatePayPalDonation(state.toPayload());
      state = state.copyWith(isLoading: false);
      return result;
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: NetworkExceptions.fromDio(e),
      );
      return null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  Future<bool> capturePayPal(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(donationRepositoryProvider);
      await repo.capturePayPalDonation(orderId);
      state = state.copyWith(isLoading: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: NetworkExceptions.fromDio(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final donationNotifierProvider =
    NotifierProvider<DonationNotifier, DonationState>(DonationNotifier.new);

final myDonationsProvider = FutureProvider.autoDispose<List<dynamic>>((
  ref,
) async {
  final repo = ref.read(donationRepositoryProvider);
  return repo.getMyDonations();
});
