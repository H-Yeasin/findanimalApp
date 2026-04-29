import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/models/gift_card_model.dart';
import '../../data/repositories/payment_repository.dart';

class PaymentState {
  const PaymentState({
    required this.paymentMethods,
    this.giftCard,
  });

  final List<PaymentMethodModel> paymentMethods;
  final GiftCardModel? giftCard;
}

class PaymentNotifier extends AsyncNotifier<PaymentState> {
  @override
  Future<PaymentState> build() async {
    final repo = ref.read(paymentRepositoryProvider);
    final methods = await repo.getPaymentMethods();
    
    // Gift card is still mocked for now as per instructions
    return PaymentState(
      paymentMethods: methods,
      giftCard: const GiftCardModel(
        id: '1',
        balance: 0.00,
        currency: 'EUR',
      ),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  Future<Map<String, dynamic>> createSetupIntent() async {
    return await ref.read(paymentRepositoryProvider).createSetupIntent();
  }

  Future<void> deletePaymentMethod(String id) async {
    await ref.read(paymentRepositoryProvider).deletePaymentMethod(id);
    await refresh();
  }

  Future<void> setDefault(String id) async {
    await ref.read(paymentRepositoryProvider).setDefaultPaymentMethod(id);
    await refresh();
  }
}

final paymentProvider = AsyncNotifierProvider<PaymentNotifier, PaymentState>(
  PaymentNotifier.new,
);
