import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_constants.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../storage/secure_storage_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: AppConstants.requestTimeout,
      receiveTimeout: AppConstants.requestTimeout,
      sendTimeout: AppConstants.requestTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      secureStorage,
      dio,
      onRefreshToken: () async {
        final refreshToken = await secureStorage.readRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          return null;
        }

        try {
          final refreshDio = Dio(
            BaseOptions(
              baseUrl: ApiEndpoints.baseUrl,
              connectTimeout: AppConstants.requestTimeout,
              receiveTimeout: AppConstants.requestTimeout,
              sendTimeout: AppConstants.requestTimeout,
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json,
            ),
          );

          final response = await refreshDio.post(
            ApiEndpoints.generateAccessToken,
            options: Options(
              headers: {'Authorization': 'Bearer $refreshToken'},
            ),
          );

          final rawData = response.data;
          if (rawData is! Map) {
            return null;
          }

          final envelope = Map<String, dynamic>.from(rawData);
          final data = envelope['data'];
          if (data is! Map) {
            return null;
          }

          final dataMap = Map<String, dynamic>.from(data);
          final token = dataMap['accessToken'] as String? ?? '';
          if (token.isEmpty) {
            return null;
          }

          final newRefreshToken = dataMap['refreshToken'] as String? ?? '';
          if (newRefreshToken.isNotEmpty) {
            await secureStorage.writeRefreshToken(newRefreshToken);
          }

          await secureStorage.writeAccessToken(token);
          await ref.read(authSessionProvider.notifier).updateAccessToken(token);
          return token;
        } catch (_) {
          return null;
        }
      },
      onUnauthorized: () {
        if (ref.read(authStateProvider) == AuthStatus.authenticated) {
          ref.read(authSessionProvider.notifier).logout();
        }
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});
