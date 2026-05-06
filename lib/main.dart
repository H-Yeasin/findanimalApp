import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'core/services/notification_service.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint("Firebase initialized successfully");
  } catch (e) {
    if (kDebugMode) {
      print("Firebase initialization failed: $e");
    }
  }

  final container = ProviderContainer();

  // Initialize Notification Service
  container.read(notificationServiceProvider).init();

  // Initialize timeago locales
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  runApp(
    UncontrolledProviderScope(container: container, child: const HestekaApp()),
  );
}
