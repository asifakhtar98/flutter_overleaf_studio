import 'package:dio/dio.dart';

/// Injects X-API-Key header into every request.
class ApiInterceptor extends Interceptor {
  ApiInterceptor({required this.apiKey});

  final String apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-API-Key'] = apiKey;
    handler.next(options);
  }
}
