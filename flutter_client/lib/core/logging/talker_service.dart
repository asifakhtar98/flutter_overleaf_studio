import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_latex_client/core/config/server_config.dart';

/// Injectable module that provides the single [Talker] instance
/// shared across the entire app — Dio logger, Bloc observer,
/// route observer, and manual log calls all use this.
@module
abstract class TalkerModule {
  @lazySingleton
  Talker talker(ServerConfig config) {
    final isDev = config.environment == ServerEnvironment.development;

    return TalkerFlutter.init(
      settings: TalkerSettings(
        useConsoleLogs: true,
        enabled: true,
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          level: isDev ? LogLevel.verbose : LogLevel.warning,
          enableColors: true,
        ),
      ),
    );
  }
}
