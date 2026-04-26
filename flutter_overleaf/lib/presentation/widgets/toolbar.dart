import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/health/presentation/widgets/connection_indicator.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_state.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_state.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_state.dart';

class Toolbar extends HookWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: LatexTheme.background,
        border: Border(bottom: BorderSide(color: LatexTheme.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Logo / title
          const Icon(Icons.auto_stories, size: 20, color: LatexTheme.primary),
          const SizedBox(width: 8),
          const Text(
            'LaTeX Editor',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: LatexTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 24),

          // Compile button + target indicator
          const _CompileButton(),
          const SizedBox(width: 8),
          const _CompileTarget(),
          const SizedBox(width: 8),
          const ConnectionIndicator(),

          const Spacer(),

          // Compile time
          BlocBuilder<CompilerBloc, CompilerState>(
            builder: (context, state) {
              return switch (state) {
                CompilerSuccess(:final result) => _CompileTime(
                  time: result.compilationTime,
                  warnings: result.warningsCount,
                  cached: result.cached,
                ),
                CompilerFailure(:final compilationTime)
                    when compilationTime != null =>
                  _CompileTime(time: compilationTime, isError: true),
                _ => const SizedBox.shrink(),
              };
            },
          ),
        ],
      ),
    );
  }
}

/// Shows the resolved entry file name next to the compile button,
/// so the user always knows which file will be compiled.
class _CompileTarget extends StatelessWidget {
  const _CompileTarget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, editorState) {
        return BlocBuilder<ProjectBloc, ProjectState>(
          builder: (context, projectState) {
            final entryFile = resolveEntryFile(
              activePath: editorState.currentTabPath,
              activeContent: editorState.content,
              mainFilePath: projectState.mainFilePath,
            );
            if (entryFile == null) return const SizedBox.shrink();

            final fileName = entryFile.split('/').last;
            final isActiveOverride = entryFile == editorState.currentTabPath &&
                entryFile != projectState.mainFilePath;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 13,
                  color: LatexTheme.textSecondary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActiveOverride
                        ? LatexTheme.primary
                        : LatexTheme.textSecondary,
                    fontWeight:
                        isActiveOverride ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Determines the compile entry file using Overleaf logic:
/// 1. If active file contains \documentclass → compile it
/// 2. Else → use project's mainFilePath
String? resolveEntryFile({
  required String? activePath,
  required String activeContent,
  required String? mainFilePath,
}) {
  // Overleaf behavior: active file with \documentclass takes priority
  if (activePath != null && activeContent.contains(r'\documentclass')) {
    return activePath;
  }
  return mainFilePath ?? activePath;
}

class _CompileButton extends StatelessWidget {
  const _CompileButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompilerBloc, CompilerState>(
      builder: (context, compilerState) {
        final isLoading = compilerState is CompilerLoading;
        return BlocBuilder<ProjectBloc, ProjectState>(
          builder: (context, projectState) {
            return BlocBuilder<EditorBloc, EditorState>(
              builder: (context, editorState) {
                final entryFile = resolveEntryFile(
                  activePath: editorState.currentTabPath,
                  activeContent: editorState.content,
                  mainFilePath: projectState.mainFilePath,
                );
                final hasEntry =
                    entryFile != null &&
                    projectState.files.any((f) => f.path == entryFile);
                final canCompile = !isLoading && hasEntry;

                return Tooltip(
                  message: canCompile
                      ? 'Compile (⌘S)'
                      : isLoading
                          ? 'Compilation in progress'
                          : 'No compilable file',
                  waitDuration: const Duration(milliseconds: 400),
                  child: FilledButton.icon(
                    onPressed: canCompile
                        ? () => _compile(context)
                        : null,
                    icon: isLoading
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.play_arrow, size: 18),
                    label: Text(isLoading ? 'Compiling…' : 'Compile'),
                    style: FilledButton.styleFrom(
                      backgroundColor: LatexTheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 34),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// Read fresh state at press time — avoids stale closure captures
  /// when ProjectBloc and EditorBloc update out of sync.
  void _compile(BuildContext context) {
    final editorState = context.read<EditorBloc>().state;
    final projectState = context.read<ProjectBloc>().state;

    final entryFile = resolveEntryFile(
      activePath: editorState.currentTabPath,
      activeContent: editorState.content,
      mainFilePath: projectState.mainFilePath,
    );

    if (entryFile == null) return;
    if (!projectState.files.any((f) => f.path == entryFile)) return;

    final activePath = editorState.currentTabPath;

    // Flush active editor content to project
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

class _CompileTime extends StatelessWidget {
  const _CompileTime({
    required this.time,
    this.warnings = 0,
    this.cached = false,
    this.isError = false,
  });

  final double time;
  final int warnings;
  final bool cached;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (warnings > 0) ...[
          const Icon(Icons.warning_amber, size: 14, color: LatexTheme.warning),
          const SizedBox(width: 4),
          Text(
            '$warnings',
            style: const TextStyle(fontSize: 12, color: LatexTheme.warning),
          ),
          const SizedBox(width: 12),
        ],
        Icon(
          isError ? Icons.timer_off : Icons.timer_outlined,
          size: 14,
          color: isError ? LatexTheme.error : LatexTheme.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          '${time.toStringAsFixed(2)}s',
          style: TextStyle(
            fontSize: 12,
            color: isError ? LatexTheme.error : LatexTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (cached) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: LatexTheme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'cached',
              style: TextStyle(
                fontSize: 10,
                color: LatexTheme.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
