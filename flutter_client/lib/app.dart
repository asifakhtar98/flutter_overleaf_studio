import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_latex_client/core/config/server_config.dart';
import 'package:flutter_latex_client/core/di/injection.dart';
import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_state.dart';
import 'package:flutter_latex_client/presentation/pages/editor_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProjectBloc>()),
        BlocProvider(
          create: (context) {
            final projectBloc = context.read<ProjectBloc>();
            final editorBloc = getIt<EditorBloc>();

            final activeFile = projectBloc.state.files
                .where((f) => f.path == projectBloc.state.activeFilePath)
                .firstOrNull;

            if (activeFile != null) {
              editorBloc.add(
                EditorEvent.fileOpened(
                  path: activeFile.path,
                  content: activeFile.content,
                ),
              );
            }
            return editorBloc;
          },
        ),
        BlocProvider(create: (_) => getIt<CompilerBloc>()),
      ],
      child: _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final talker = getIt<Talker>();
    final isDev =
        getIt<ServerConfig>().environment == ServerEnvironment.development;

    // Auto-open first file on start
    return MultiBlocListener(
      listeners: [
        // Sync project → editor when active file changes
        BlocListener<ProjectBloc, ProjectState>(
          listenWhen: (previous, current) =>
              previous.activeFilePath != current.activeFilePath,
          listener: (context, state) {
            final activeFile = state.files
                .where((f) => f.path == state.activeFilePath)
                .firstOrNull;
            if (activeFile != null) {
              context.read<EditorBloc>().add(
                EditorEvent.fileOpened(
                  path: activeFile.path,
                  content: activeFile.content,
                ),
              );
            }
          },
        ),
        // OL5: Show snackbar on import/export errors
        BlocListener<ProjectBloc, ProjectState>(
          listenWhen: (prev, curr) =>
              curr.importError != null && prev.importError != curr.importError,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.importError!),
                backgroundColor: LatexTheme.error,
              ),
            );
          },
        ),
      ],
      child: TalkerWrapper(
        talker: talker,
        options: TalkerWrapperOptions(enableErrorAlerts: isDev),
        child: MaterialApp(
          title: 'LaTeX Editor',
          theme: LatexTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [TalkerRouteObserver(talker)],
          home: const EditorPage(),
        ),
      ),
    );
  }
}
