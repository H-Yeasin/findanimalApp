import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/payment_method_model.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.watch(apiClientProvider));
});

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await _apiClient.get(ApiEndpoints.paymentMethods);
    final List data = response.data['data'] ?? [];
    return data.map((json) {
      return PaymentMethodModel(
        id: json['id'],
        type: json['type'] == 'visa'
            ? AppPaymentMethodType.visa
            : AppPaymentMethodType.mastercard,
        lastFour: json['lastFour'],
        cardholderName: json['cardholderName'],
        expiryDate: json['expiryDate'],
        isDefault: json['isDefault'] ?? false,
      );
    }).toList();
  }

  Future<Map<String, dynamic>> createSetupIntent() async {
    final response = await _apiClient.post(
      ApiEndpoints.stripeCreateSetupIntent,
    );
    return {
      'clientSecret': response.data['data']['clientSecret'],
      'customerId': response.data['data']['customerId'],
      'customerEphemeralKeySecret':
          response.data['data']['customerEphemeralKeySecret'],
    };
  }

  Future<void> deletePaymentMethod(String id) async {
    await _apiClient.delete(ApiEndpoints.deletePaymentMethod(id));
  }

  Future<void> setDefaultPaymentMethod(String id) async {
    await _apiClient.post(ApiEndpoints.setDefaultPaymentMethod(id));
  }
}
