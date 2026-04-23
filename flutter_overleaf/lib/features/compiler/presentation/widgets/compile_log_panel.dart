import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_state.dart';

class CompileLogPanel extends StatefulWidget {
  const CompileLogPanel({super.key});

  @override
  State<CompileLogPanel> createState() => _CompileLogPanelState();
}

class _CompileLogPanelState extends State<CompileLogPanel> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompilerBloc, CompilerState>(
      builder: (context, state) {
        final log = switch (state) {
          CompilerFailure(:final log) => log,
          CompilerSuccess(:final result) => result.log,
          _ => null,
        };

        if (log == null || log.isEmpty) return const SizedBox.shrink();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: _expanded ? 180 : 32,
          decoration: const BoxDecoration(
            color: LatexTheme.logBg,
            border: Border(top: BorderSide(color: LatexTheme.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header — clickable to toggle
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: LatexTheme.logBg.withValues(alpha: 0.95),
                    border: const Border(
                      bottom: BorderSide(color: Color(0xFF374151)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        size: 16,
                        color: LatexTheme.logText,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        state is CompilerFailure
                            ? Icons.error_outline
                            : Icons.terminal,
                        size: 14,
                        color: state is CompilerFailure
                            ? LatexTheme.error
                            : LatexTheme.logText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Compilation Log',
                        style: LatexTheme.monoSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (state case CompilerFailure(:final compilationTime))
                        if (compilationTime != null)
                          Text(
                            '${compilationTime.toStringAsFixed(2)}s',
                            style: LatexTheme.monoSmall,
                          ),
                      if (state case CompilerSuccess(:final result))
                        Text(
                          '${result.compilationTime.toStringAsFixed(2)}s',
                          style: LatexTheme.monoSmall,
                        ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => context.read<CompilerBloc>().add(
                          const CompilerEvent.reset(),
                        ),
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: LatexTheme.logText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Log content — only when expanded
              if (_expanded)
                Expanded(child: _AutoScrollLog(log: log)),
            ],
          ),
        );
      },
    );
  }
}

class _AutoScrollLog extends StatefulWidget {
  const _AutoScrollLog({required this.log});
  final String log;

  @override
  State<_AutoScrollLog> createState() => _AutoScrollLogState();
}

class _AutoScrollLogState extends State<_AutoScrollLog> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void didUpdateWidget(_AutoScrollLog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.log != oldWidget.log) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      child: SelectableText(widget.log, style: LatexTheme.monoSmall),
    );
  }
}
