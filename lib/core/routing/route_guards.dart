import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import 'route_names.dart';

String? routeGuard(AuthStatus authStatus, GoRouterState state) {
  final location = state.uri.path;

  const protectedPrefixes = <String>[
    '/my-profile',
    '/main/profile',
    '/profile',
    '/points',
    '/reports/create',
    '/missions',
    '/collection-points',
  ];

  final isAuthRoute = location.startsWith('/auth');
  final isPasswordRecoveryRoute =
      location == RouteNames.forgotPassword ||
      location == RouteNames.verifyOtp ||
      location == RouteNames.resetPassword;
  final requiresAuth = protectedPrefixes.any(location.startsWith);

  if (authStatus == AuthStatus.authenticated &&
      isAuthRoute &&
      !isPasswordRecoveryRoute) {
    return RouteNames.root;
  }

  if (authStatus == AuthStatus.unauthenticated && requiresAuth) {
    return RouteNames.account;
  }

  return null;
}
