import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_latex_client/core/config/server_config.dart';
import 'package:flutter_latex_client/core/di/injection.dart';
import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_state.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_state.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_state.dart';

class Toolbar extends HookWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final draftMode = useState(false);

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

          // Draft toggle (kept in toolbar per user request)
          Tooltip(
            message: 'Draft mode — skips image rendering for faster compile',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Draft',
                  style: TextStyle(
                    fontSize: 12,
                    color: LatexTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  height: 24,
                  child: Switch(
                    value: draftMode.value,
                    onChanged: (v) => draftMode.value = v,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Compile button
          _CompileButton(draftMode: draftMode.value),
          const SizedBox(width: 8),

          // Import project
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              if (state.isImporting) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: LatexTheme.textSecondary,
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.folder_open_outlined, size: 18),
                tooltip: 'Import ZIP project',
                onPressed: () {
                  context.read<ProjectBloc>().add(
                    const ProjectEvent.importProject(),
                  );
                },
                color: LatexTheme.textSecondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              );
            },
          ),

          // Export project
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              if (state.isExporting) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: LatexTheme.textSecondary,
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.save_alt_outlined, size: 18),
                tooltip: 'Export as ZIP',
                onPressed: () {
                  context.read<ProjectBloc>().add(
                    const ProjectEvent.exportProject(),
                  );
                },
                color: LatexTheme.textSecondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              );
            },
          ),

          const Spacer(),

          const SizedBox(width: 16),

          // Debug log viewer (dev only)
          if (getIt<ServerConfig>().environment ==
              ServerEnvironment.development)
            IconButton(
              icon: const Icon(Icons.bug_report_outlined, size: 18),
              tooltip: 'Open log viewer',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => TalkerScreen(talker: getIt<Talker>()),
                  ),
                );
              },
              color: LatexTheme.textSecondary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),

          const SizedBox(width: 8),

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
  const _CompileButton({required this.draftMode});

  final bool draftMode;

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

                return FilledButton.icon(
                  onPressed: canCompile
                      ? () => _compile(
                          context,
                          editorState: editorState,
                          projectState: projectState,
                          entryFile: entryFile,
                        )
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
                );
              },
            );
          },
        );
      },
    );
  }

  void _compile(
    BuildContext context, {
    required EditorState editorState,
    required ProjectState projectState,
    required String entryFile,
  }) {
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

    // Build files with active content overlaid
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
        draft: draftMode,
        files: files,
        mainFile: entryFile,
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
