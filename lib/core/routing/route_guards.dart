import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import 'route_names.dart';

String? routeGuard(
  AuthStatus authStatus,
  GoRouterState state, {
  String? userRole,
}) {
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

  final isPartnerRoute = location.startsWith('/partner');
  final isPartnerAuthRoute =
      location == RouteNames.partnerAuthGateway ||
      location == RouteNames.partnerLogin ||
      location == RouteNames.partnerRegister;
  final isPartner = userRole == 'partners';
  final isAuthRoute = location.startsWith('/auth');
  final isPasswordRecoveryRoute =
      location == RouteNames.forgotPassword ||
      location == RouteNames.verifyOtp ||
      location == RouteNames.resetPassword;
  final requiresAuth = protectedPrefixes.any(location.startsWith);

  if (authStatus == AuthStatus.unknown) {
    return null;
  }

  if (authStatus == AuthStatus.unauthenticated && isPartnerRoute) {
    return RouteNames.partnerAuthGateway;
  }

  if (authStatus == AuthStatus.authenticated && isPartnerRoute && !isPartner) {
    return RouteNames.partnerAuthGateway;
  }

  if (authStatus == AuthStatus.authenticated &&
      isPartnerAuthRoute &&
      isPartner) {
    return RouteNames.partnerAccess;
  }

  if (authStatus == AuthStatus.authenticated &&
      isAuthRoute &&
      !isPasswordRecoveryRoute &&
      !isPartnerAuthRoute) {
    return RouteNames.root;
  }

  if (authStatus == AuthStatus.unauthenticated && requiresAuth) {
    return RouteNames.account;
  }

  return null;
}
