import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        BlocProvider(create: (_) => getIt<EditorBloc>()),
        BlocProvider(
          create: (context) {
            final bloc = getIt<CompilerBloc>();
            final projectBloc = context.read<ProjectBloc>();

            // Wire up project access for compiler
            bloc.getProjectFiles = () => projectBloc.state.files;
            bloc.getMainFileName = () => projectBloc.state.mainFilePath ?? 'main.tex';
            bloc.getActiveContent = () =>
                context.read<EditorBloc>().state.content;

            return bloc;
          },
        ),
      ],
      child: _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Auto-open first file on start
    return BlocListener<ProjectBloc, ProjectState>(
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
      child: MaterialApp(
        title: 'LaTeX Editor',
        theme: LatexTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const EditorPage(),
      ),
    );
  }
}
