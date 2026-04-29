import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';

final donationRepositoryProvider = Provider<DonationRepository>((ref) {
  return DonationRepository(ref.watch(apiClientProvider));
});

class DonationRepository {
  final ApiClient _apiClient;

  DonationRepository(this._apiClient);

  Future<Map<String, dynamic>> initiateStripeDonation(Map<String, dynamic> payload) async {
    final response = await _apiClient.post(
      ApiEndpoints.stripeInitiate,
      data: payload,
    );
    return response.data['data']; // Returns { clientSecret, paymentIntentId }
  }

  Future<Map<String, dynamic>> initiatePayPalDonation(Map<String, dynamic> payload) async {
    final response = await _apiClient.post(
      ApiEndpoints.paypalInitiate,
      data: payload,
    );
    return response.data['data']; // Returns { orderId, links... } or { orderId }
  }

  Future<Map<String, dynamic>> capturePayPalDonation(String orderId) async {
    final response = await _apiClient.post(
      ApiEndpoints.paypalCapture,
      data: {'orderId': orderId},
    );
    return response.data['data'];
  }

  Future<List<dynamic>> getMyDonations() async {
    final response = await _apiClient.get(ApiEndpoints.myDonations);
    return response.data['data'] ?? [];
  }
}
