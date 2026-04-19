import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/core/config/server_config.dart';
import 'package:flutter_latex_client/core/network/api_interceptor.dart';
import 'package:flutter_latex_client/core/network/error_interceptor.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(ServerConfig config) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(minutes: 3),
        sendTimeout: const Duration(minutes: 2),
      ),
    );

    dio.interceptors.addAll([
      ApiInterceptor(apiKey: config.apiKey),
      ErrorInterceptor(),
      if (config.environment == ServerEnvironment.development)
        LogInterceptor(
          requestBody: true,
          responseBody: false,
          // ignore: avoid_print — LogInterceptor needs a print callback for dev.
          logPrint: print,
        ),
    ]);

    return dio;
  }
}
