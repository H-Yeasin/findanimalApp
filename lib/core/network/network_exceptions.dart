import 'package:dio/dio.dart';

class NetworkExceptions {
  const NetworkExceptions._();

  static String fromDio(DioException error) {
    final responseMessage = error.response?.data;
    if (responseMessage is Map<String, dynamic>) {
      final message = responseMessage['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'Network error. Check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server returned an unexpected response.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return 'Unexpected network error.';
    }
  }
}
