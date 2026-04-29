import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, AsyncValue<List<NotificationModel>>>((
  ref,
) {
  return NotificationsNotifier(ref);
});

class NotificationsNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final Ref _ref;

  NotificationsNotifier(this._ref) : super(const AsyncLoading()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = _ref.read(notificationRepositoryProvider);
      final response = await repository.getMyNotifications();
      return response.data;
    });
  }

  void removeNotification(String id) {
    state.whenData((notifications) {
      final updatedList =
          notifications.where((n) => n.id != id).toList();
      state = AsyncValue.data(updatedList);
    });
  }
}

final notificationActionProvider =
    StateNotifierProvider<NotificationActionNotifier, AsyncValue<void>>((ref) {
  return NotificationActionNotifier(ref);
});

class NotificationActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  NotificationActionNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> markAsRead(String id) async {
    state = await AsyncValue.guard(() async {
      final repository = _ref.read(notificationRepositoryProvider);
      await repository.markAsRead(id);
      // Update local state to mark as read without full refresh
      _ref.read(notificationsProvider.notifier).state.whenData((list) {
        final updatedList = list.map((n) {
          if (n.id == id) {
            return NotificationModel(
              id: n.id,
              title: n.title,
              description: n.description,
              type: n.type,
              isRead: true,
              createdAt: n.createdAt,
              data: n.data,
            );
          }
          return n;
        }).toList();
        _ref.read(notificationsProvider.notifier).state = AsyncValue.data(updatedList);
      });
    });
  }

  Future<void> deleteNotification(String id) async {
    // First remove from UI for smooth experience
    _ref.read(notificationsProvider.notifier).removeNotification(id);
    
    state = await AsyncValue.guard(() async {
      final repository = _ref.read(notificationRepositoryProvider);
      await repository.deleteNotification(id);
    });
  }
}
