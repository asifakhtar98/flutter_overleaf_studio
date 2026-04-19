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
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart';

class Toolbar extends HookWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedEngine = useState('pdflatex');
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

          // Engine picker
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: LatexTheme.border),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedEngine.value,
                isDense: true,
                style: const TextStyle(fontSize: 13, color: LatexTheme.textPrimary),
                items: const [
                  DropdownMenuItem(value: 'pdflatex', child: Text('pdflatex')),
                  DropdownMenuItem(value: 'xelatex', child: Text('xelatex')),
                  DropdownMenuItem(value: 'lualatex', child: Text('lualatex')),
                ],
                onChanged: (v) => selectedEngine.value = v!,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Draft toggle
          Tooltip(
            message: 'Draft mode — skips image rendering for faster compile',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Draft',
                  style: TextStyle(fontSize: 12, color: LatexTheme.textSecondary),
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
          BlocBuilder<CompilerBloc, CompilerState>(
            builder: (context, state) {
              final isLoading = state is CompilerLoading;
              return FilledButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                        final projectState =
                            context.read<ProjectBloc>().state;
                        final editorState =
                            context.read<EditorBloc>().state;
                        context.read<CompilerBloc>().add(
                              CompilerEvent.compileRequested(
                                engine: selectedEngine.value,
                                draft: draftMode.value,
                                source: editorState.content,
                                files: projectState.files,
                                mainFile:
                                    projectState.mainFilePath ?? 'main.tex',
                              ),
                            );
                      },
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  minimumSize: const Size(0, 34),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),

          const Spacer(),

          // Debug log viewer (dev only)
          if (getIt<ServerConfig>().environment ==
              ServerEnvironment.development)
            IconButton(
              icon: const Icon(Icons.bug_report_outlined, size: 18),
              tooltip: 'Open log viewer',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => TalkerScreen(
                      talker: getIt<Talker>(),
                    ),
                  ),
                );
              },
              color: LatexTheme.textSecondary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
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
                  _CompileTime(
                    time: compilationTime,
                    isError: true,
                  ),
                _ => const SizedBox.shrink(),
              };
            },
          ),
        ],
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
