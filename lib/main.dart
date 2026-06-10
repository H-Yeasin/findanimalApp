import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/env.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timeago/timeago.dart' as timeago;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    Env.validateReleaseConfig();
  }

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    debugPrint("Firebase initialized successfully");
  } catch (e) {
    if (kDebugMode) {
      print("Firebase initialization failed: $e");
    }
  }

  final container = ProviderContainer();

  // Initialize Notification Service
  container.read(notificationServiceProvider).init();

  // Resolve persisted auth session before first paint so auth-dependent UI
  // does not spend as long in the "unknown" state.
  await container.read(authSessionProvider.future);

  // Initialize timeago locales
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  runApp(
    UncontrolledProviderScope(container: container, child: const HestekaApp()),
  );
}
