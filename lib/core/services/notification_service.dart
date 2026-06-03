import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../routing/app_router.dart';
import '../routing/route_names.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

class NotificationService {
  NotificationService(this._ref);

  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Request permissions for iOS
    if (Platform.isIOS) {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    }

    // 2. Initialize local notifications for foreground
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // 3. Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // Check if app was launched from terminated state via a notification tap
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleNotificationTap(initialMessage);
      });
    }

    // 4. Handle background state when app is opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    // 5. Sync token when authenticated
    _ref.listen(authStateProvider, (previous, next) {
      if (next == AuthStatus.authenticated) {
        syncToken();
      }
    }, fireImmediately: true);

    // Listen for token refreshes
    _messaging.onTokenRefresh.listen((newToken) {
      final authStatus = _ref.read(authStateProvider);
      if (authStatus == AuthStatus.authenticated) {
        _ref.read(profileRepositoryProvider).updateFcmToken(newToken);
      }
    });
  }

  void _handleNotificationTap(RemoteMessage message) {
    final type = message.data['type'];
    final router = _ref.read(appRouterProvider);

    if (type == 'report' || type == 'new_report') {
      router.push(RouteNames.reports);
    } else if (type == 'comment' || type == 'like') {
      router.push(RouteNames.mainCommunity);
    } else {
      router.push(RouteNames.mainNotifications);
    }
  }

  Future<void> syncToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _ref.read(profileRepositoryProvider).updateFcmToken(token);
        if (kDebugMode) {
          print('FCM Token synced: $token');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing FCM token: $e');
      }
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final _ = message.notification?.android;

    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }
}
