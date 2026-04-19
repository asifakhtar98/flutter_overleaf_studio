import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/core/config/server_config.dart';
import 'package:flutter_latex_client/core/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies({required ServerConfig serverConfig}) {
  getIt.registerSingleton<ServerConfig>(serverConfig);
  getIt.init();
}
