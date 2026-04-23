import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter_overleaf/core/error/exceptions.dart';

/// Maps DioExceptions to typed domain exceptions.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException(message: 'Connection failed'),
          type: err.type,
        ),
      );
      return;
    }

    if (response != null) {
      dynamic data = response.data;
      if (data is List<int>) {
        try {
          final str = utf8.decode(data);
          data = jsonDecode(str);
        } on FormatException catch (_) {}
      }

      if (data is Map<String, dynamic>) {
        final errorCode = data['error_code'] as String? ?? 'UNKNOWN';
        final message = data['message'] as String? ?? 'Unknown error';
        final detail = data['detail'] as Map<String, dynamic>?;
        final requestId = data['request_id'] as String?;

        if (errorCode == 'COMPILATION_FAILED') {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: CompilationException(
                log: detail?['log'] as String? ?? '',
                errorCode: errorCode,
                compilationTime: (detail?['compilation_time'] as num?)
                    ?.toDouble(),
                requestId: requestId,
              ),
              type: err.type,
              response: response,
            ),
          );
          return;
        }

        if (errorCode == 'MISSING_API_KEY' ||
            errorCode == 'INVALID_API_KEY') {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: AuthException(
                message: message,
                errorCode: errorCode,
                requestId: requestId,
              ),
              type: err.type,
              response: response,
            ),
          );
          return;
        }

        if (errorCode == 'RATE_LIMITED') {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: RateLimitException(
                message: message,
                requestId: requestId,
              ),
              type: err.type,
              response: response,
            ),
          );
          return;
        }

        if (errorCode == 'UPLOAD_TOO_LARGE') {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: UploadTooLargeException(
                message: message,
                requestId: requestId,
              ),
              type: err.type,
              response: response,
            ),
          );
          return;
        }

        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(
              message: message,
              statusCode: response.statusCode,
              errorCode: errorCode,
              requestId: requestId,
            ),
            type: err.type,
            response: response,
          ),
        );
        return;
      }
    }

    handler.next(err);
  }
}
