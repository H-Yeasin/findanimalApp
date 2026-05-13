import 'dart:ui';

import 'package:dio/dio.dart';

import '../storage/secure_storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(
    this._secureStorageService,
    this._dio, {
    this.onUnauthorized,
    this.onRefreshToken,
  });

  final SecureStorageService _secureStorageService;
  final Dio _dio;
  final VoidCallback? onUnauthorized;
  final Future<String?> Function()? onRefreshToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorageService.readAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;
      final hasToken = err.requestOptions.headers.containsKey('Authorization');
      final alreadyRetried = err.requestOptions.extra['_retried'] == true;

      if (hasToken &&
          !path.contains('/auth/logout') &&
          !path.contains('/auth/generate-access-token') &&
          !alreadyRetried) {
        final refreshedToken = await onRefreshToken?.call();

        if (refreshedToken != null && refreshedToken.isNotEmpty) {
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $refreshedToken';
          requestOptions.extra['_retried'] = true;

          try {
            final response = await _dio.fetch(requestOptions);
            handler.resolve(response);
            return;
          } on DioException catch (retryError) {
            if (retryError.response?.statusCode != 401) {
              handler.next(retryError);
              return;
            }
          }
        }

        onUnauthorized?.call();
      }
    }
    handler.next(err);
  }
}
