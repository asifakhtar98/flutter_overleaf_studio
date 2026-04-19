import 'dart:async';

import 'package:flutter/material.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_latex_client/app.dart';
import 'package:flutter_latex_client/core/config/server_config.dart';
import 'package:flutter_latex_client/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  // Configure DI with server config
  configureDependencies(
    serverConfig: const ServerConfig(
      baseUrl: 'http://localhost:8080',
      apiKey: 'dev-api-key',
      environment: ServerEnvironment.development,
    ),
  );

  final talker = getIt<Talker>();

  // Auto-log every Bloc event, transition, and error
  Bloc.observer = TalkerBlocObserver(talker: talker);

  // Catch Flutter framework errors (rendering, layout, etc.)
  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack);
  };

  // Catch uncaught async errors (unhandled futures, isolates)
  runZonedGuarded(
    () => runApp(const App()),
    talker.handle,
  );
}
