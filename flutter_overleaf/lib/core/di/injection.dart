import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_overleaf/core/config/server_config.dart';
import 'package:flutter_overleaf/core/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies({required ServerConfig serverConfig}) {
  getIt.registerSingleton<ServerConfig>(serverConfig);
  getIt.init();
}
