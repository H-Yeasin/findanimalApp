import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/paginated_response.dart';
import '../models/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(apiClientProvider));
});

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  Future<PaginatedResponse<NotificationModel>> getMyNotifications({
    int page = 1,
    int limit = 30,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.getMyNotifications,
      queryParameters: {'page': page, 'limit': limit},
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => NotificationModel.fromJson(json),
    );
  }

  Future<void> markAsRead(String id) async {
    await _apiClient.patch(ApiEndpoints.markNotificationAsRead(id));
  }

  Future<void> deleteNotification(String id) async {
    await _apiClient.delete(ApiEndpoints.deleteNotification(id));
  }
}
