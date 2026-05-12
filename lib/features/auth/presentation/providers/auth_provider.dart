import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../data/models/auth_user_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_partner_request_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/localization/app_localizations.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthSession {
  const AuthSession({
    required this.status,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  final AuthStatus status;
  final String? accessToken;
  final String? refreshToken;
  final AuthUserModel? user;
}

class AuthSessionNotifier extends AsyncNotifier<AuthSession> {
  @override
  Future<AuthSession> build() async {
    final secureStorage = ref.read(secureStorageProvider);

    final accessToken = await secureStorage.readAccessToken();
    final refreshToken = await secureStorage.readRefreshToken();
    final rawUser = await secureStorage.readCurrentUser();

    AuthUserModel? user;
    if (rawUser != null && rawUser.isNotEmpty) {
      try {
        user = AuthUserModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(rawUser) as Map),
        );
      } catch (_) {
        user = null;
      }
    }

    if (accessToken != null && accessToken.isNotEmpty) {
      return AuthSession(
        status: AuthStatus.authenticated,
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
      );
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        final repository = ref.read(authRepositoryProvider);
        final newAccessToken = await repository.generateAccessToken(
          refreshToken,
        );

        if (newAccessToken.isNotEmpty) {
          await secureStorage.writeAccessToken(newAccessToken);
          return AuthSession(
            status: AuthStatus.authenticated,
            accessToken: newAccessToken,
            refreshToken: refreshToken,
            user: user,
          );
        }
      } catch (_) {
        await secureStorage.clearSession();
      }
    }

    return const AuthSession(status: AuthStatus.unauthenticated);
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final secureStorage = ref.read(secureStorageProvider);

      final session = await repository.login(
        LoginRequestModel(email: email, password: password),
      );

      if (session.accessToken.isNotEmpty) {
        await secureStorage.writeAccessToken(session.accessToken);
      }
      if (session.refreshToken.isNotEmpty) {
        await secureStorage.writeRefreshToken(session.refreshToken);
      }

      await secureStorage.writeCurrentUser(jsonEncode(session.user.toJson()));

      final authSession = AuthSession(
        status: AuthStatus.authenticated,
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        user: session.user,
      );

      state = AsyncData(authSession);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    final session = state.valueOrNull;
    if (session == null || session.status == AuthStatus.unauthenticated) {
      return;
    }

    final repository = ref.read(authRepositoryProvider);
    final secureStorage = ref.read(secureStorageProvider);

    // Set state to unauthenticated immediately to prevent further triggers 
    // from concurrent 401 errors.
    state = const AsyncData(AuthSession(status: AuthStatus.unauthenticated));

    try {
      await repository.logout();
    } catch (_) {
      // Even if backend logout fails, we clear local session to avoid stale auth state.
    }

    await secureStorage.clearSession();
  }
}

class AuthActionNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> registerUser(RegisterRequestModel request) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).registerUser(request);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> registerPartner(RegisterPartnerRequestModel request) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).registerPartner(request);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> verifyAccount({
    required String email,
    required String otp,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .verifyAccount(email: email, otp: otp);
    });
  }

  Future<void> forgetPassword({required String email}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).forgetPassword(email: email);
    });
  }

  Future<String> verifyPasswordOtp({
    required String email,
    required String otp,
  }) async {
    state = const AsyncLoading();

    try {
      final token = await ref
          .read(authRepositoryProvider)
          .verifyPasswordOtp(email: email, otp: otp);
      state = const AsyncData(null);
      return token;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(
            token: token,
            password: password,
            confirmPassword: confirmPassword,
          );
    });
  }
}

final authSessionProvider =
    AsyncNotifierProvider<AuthSessionNotifier, AuthSession>(
      AuthSessionNotifier.new,
    );

final authActionProvider =
    AutoDisposeAsyncNotifierProvider<AuthActionNotifier, void>(
      AuthActionNotifier.new,
    );

final authStateProvider = Provider<AuthStatus>((ref) {
  final session = ref.watch(authSessionProvider);

  return session.maybeWhen(
    data: (data) => data.status,
    orElse: () => AuthStatus.unknown,
  );
});

final accessTokenProvider = Provider<String?>((ref) {
  return ref.watch(authSessionProvider).valueOrNull?.accessToken;
});

final currentUserProvider = Provider<AuthUserModel?>((ref) {
  return ref.watch(authSessionProvider).valueOrNull?.user;
});

String authErrorMessage(Object error, [AppLocalizations? l10n]) {
  final raw = error.toString().toLowerCase();

  if (raw.contains('user not found') || raw.contains('incorrect password')) {
    return l10n?.credentialIncorrect ??
        'Credential incorrect. Try with correct credential or create an account.';
  }

  if (raw.contains('uppercase') &&
      raw.contains('lowercase') &&
      raw.contains('number') &&
      raw.contains('special character')) {
    return l10n?.passwordValidationComplexity ?? error.toString();
  }

  final msg = error.toString();
  if (msg.startsWith('Exception: ')) {
    return msg.replaceFirst('Exception: ', '');
  }
  return msg;
}
