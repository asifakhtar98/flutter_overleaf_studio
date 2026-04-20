import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_overleaf/core/config/server_config.dart';
import 'package:flutter_overleaf/core/network/api_interceptor.dart';
import 'package:flutter_overleaf/core/network/error_interceptor.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(ServerConfig config, Talker talker) {
    final isDev = config.environment == ServerEnvironment.development;

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
      TalkerDioLogger(
        talker: talker,
        settings: TalkerDioLoggerSettings(
          printRequestHeaders: isDev,
          printResponseHeaders: isDev,
          printResponseMessage: true,
        ),
      ),
    ]);

    return dio;
  }
}
