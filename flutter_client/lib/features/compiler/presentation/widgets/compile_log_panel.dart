import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_state.dart';

class CompileLogPanel extends StatelessWidget {
  const CompileLogPanel({super.key});

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

        return Container(
          height: 180,
          decoration: const BoxDecoration(
            color: LatexTheme.logBg,
            border: Border(top: BorderSide(color: LatexTheme.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: LatexTheme.logBg.withValues(alpha: 0.95),
                  border: const Border(
                    bottom: BorderSide(color: Color(0xFF374151)),
                  ),
                ),
                child: Row(
                  children: [
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
                    // RM3: Close button
                    InkWell(
                      onTap: () => context
                          .read<CompilerBloc>()
                          .add(const CompilerEvent.reset()),
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
              // Log content — RM4: auto-scroll to bottom
              Expanded(
                child: _AutoScrollLog(log: log),
              ),
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
