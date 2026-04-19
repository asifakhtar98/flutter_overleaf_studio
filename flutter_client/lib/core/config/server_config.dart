import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_config.freezed.dart';

/// Server environment for dev/prod switching.
enum ServerEnvironment { development, production }

@freezed
sealed class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    required String baseUrl,
    required String apiKey,
    @Default(ServerEnvironment.production) ServerEnvironment environment,
  }) = _ServerConfig;
}
