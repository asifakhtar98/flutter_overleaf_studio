import 'package:dio/dio.dart';

import 'package:flutter_latex_client/core/error/exceptions.dart';

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
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final errorCode = data['error_code'] as String? ?? 'UNKNOWN';
        final message = data['message'] as String? ?? 'Unknown error';
        final detail = data['detail'] as Map<String, dynamic>?;

        if (errorCode == 'COMPILATION_FAILED') {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: CompilationException(
                log: detail?['log'] as String? ?? '',
                errorCode: errorCode,
                compilationTime: (detail?['compilation_time'] as num?)
                    ?.toDouble(),
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
