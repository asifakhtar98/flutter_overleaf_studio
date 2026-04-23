import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_state.dart';
import 'package:flutter_overleaf/features/compiler/presentation/widgets/compile_log_panel.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_overleaf/presentation/widgets/responsive_layout.dart';
import 'package:flutter_overleaf/presentation/widgets/toolbar.dart';

/// Intent for Cmd+S / Ctrl+S compile shortcut.
class CompileIntent extends Intent {
  const CompileIntent();
}

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyS, meta: true): CompileIntent(),
        SingleActivator(LogicalKeyboardKey.keyS, control: true):
            CompileIntent(),
      },
      child: Actions(
        actions: {
          CompileIntent: CallbackAction<CompileIntent>(
            onInvoke: (_) => _triggerCompile(context),
          ),
        },
        child: const Focus(
          autofocus: true,
          child: Scaffold(
            body: Column(
              children: [
                Toolbar(),
                Expanded(child: ResponsiveLayout()),
                CompileLogPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _triggerCompile(BuildContext context) {
    final compilerState = context.read<CompilerBloc>().state;
    if (compilerState is CompilerLoading) return;

    final editorState = context.read<EditorBloc>().state;
    final projectState = context.read<ProjectBloc>().state;

    final entryFile = resolveEntryFile(
      activePath: editorState.currentTabPath,
      activeContent: editorState.content,
      mainFilePath: projectState.mainFilePath,
    );

    if (entryFile == null) return;
    if (!projectState.files.any((f) => f.path == entryFile)) return;

    // Flush active content
    final activePath = editorState.currentTabPath;
    if (activePath != null) {
      context.read<ProjectBloc>().add(
        ProjectEvent.updateFileContent(
          path: activePath,
          content: editorState.content,
        ),
      );
    }

    // Active file content is overlaid directly in the compile payload
    // to bypass the 300ms debounce. Other files are guaranteed fresh
    // because content is flushed synchronously on every tab switch (#2).
    final files = activePath != null
        ? projectState.files.map((f) {
            if (f.path == activePath) {
              return f.copyWith(content: editorState.content);
            }
            return f;
          }).toList()
        : projectState.files;

    context.read<CompilerBloc>().add(
      CompilerEvent.compileRequested(
        engine: projectState.engine,
        draft: projectState.draftMode,
        files: files,
        mainFile: entryFile,
        enableCache: projectState.enableCache,
      ),
    );
  }
}
