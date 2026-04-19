import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_latex_client/app.dart';
import 'package:flutter_latex_client/core/config/server_config.dart';
import 'package:flutter_latex_client/core/di/injection.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Init HydratedBloc storage
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
      );

      // Configure DI with server config
      configureDependencies(
        serverConfig: const ServerConfig(
          baseUrl: 'http://localhost:8080',
          apiKey: 'dev-key-4523636',
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

      runApp(const App());
    },
    (error, stack) {
      if (getIt.isRegistered<Talker>()) {
        getIt<Talker>().handle(error, stack);
      } else {
        debugPrint('Uncaught error before DI init: $error\n$stack');
      }
    },
  );
}
