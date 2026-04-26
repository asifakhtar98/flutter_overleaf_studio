import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/compiler/domain/entities/log_entry.dart';
import 'package:flutter_overleaf/features/compiler/domain/utils/latex_log_parser.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_state.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart';

class CompileLogPanel extends StatefulWidget {
  const CompileLogPanel({super.key});

  @override
  State<CompileLogPanel> createState() => _CompileLogPanelState();
}

class _CompileLogPanelState extends State<CompileLogPanel> {
  bool _expanded = true;
  bool _showRawLog = false;
  String? _cachedLog;
  List<LogEntry> _cachedEntries = const [];

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

        // Cache parsed entries — only re-parse when log string changes.
        if (log != _cachedLog) {
          _cachedLog = log;
          _cachedEntries = parseLatexLog(log);
        }
        final entries = _cachedEntries;

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
                      if (entries.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _EntryBadge(entries: entries),
                      ],
                      const Spacer(),
                      // Toggle raw log button
                      if (entries.isNotEmpty)
                        InkWell(
                          onTap: () =>
                              setState(() => _showRawLog = !_showRawLog),
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              _showRawLog ? 'Parsed' : 'Raw',
                              style: LatexTheme.monoSmall.copyWith(
                                fontSize: 10,
                                color: LatexTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
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
                Expanded(
                  child: entries.isNotEmpty && !_showRawLog
                      ? _StructuredLogView(entries: entries)
                      : _AutoScrollLog(log: log),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Badge showing error/warning counts in the header.
class _EntryBadge extends StatelessWidget {
  const _EntryBadge({required this.entries});
  final List<LogEntry> entries;

  @override
  Widget build(BuildContext context) {
    final errors = entries.where((e) => e.severity == LogSeverity.error).length;
    final warnings =
        entries.where((e) => e.severity == LogSeverity.warning).length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (errors > 0)
          _badge('$errors', LatexTheme.error),
        if (warnings > 0) ...[
          if (errors > 0) const SizedBox(width: 4),
          _badge('$warnings', LatexTheme.warning),
        ],
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Structured log view with tappable entries that navigate to source.
class _StructuredLogView extends StatelessWidget {
  const _StructuredLogView({required this.entries});
  final List<LogEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _LogEntryTile(entry: entry);
      },
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  const _LogEntryTile({required this.entry});
  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final canNavigate = entry.filePath != null && entry.line != null;

    return InkWell(
      onTap: canNavigate ? () => _navigateToSource(context) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                _severityIcon,
                size: 14,
                color: _severityColor,
              ),
            ),
            const SizedBox(width: 8),
            if (entry.filePath != null || entry.line != null)
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  _locationLabel,
                  style: LatexTheme.monoSmall.copyWith(
                    color: canNavigate
                        ? const Color(0xFF93C5FD) // clickable blue
                        : LatexTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            if (entry.filePath != null || entry.line != null)
              const SizedBox(width: 8),
            Expanded(
              child: Text(
                entry.message,
                style: LatexTheme.monoSmall.copyWith(fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _locationLabel {
    if (entry.filePath != null && entry.line != null) {
      return '${entry.filePath}:${entry.line}';
    }
    if (entry.line != null) return 'l.${entry.line}';
    return entry.filePath ?? '';
  }

  IconData get _severityIcon => switch (entry.severity) {
        LogSeverity.error => Icons.error,
        LogSeverity.warning => Icons.warning_amber,
        LogSeverity.info => Icons.info_outline,
      };

  Color get _severityColor => switch (entry.severity) {
        LogSeverity.error => LatexTheme.error,
        LogSeverity.warning => LatexTheme.warning,
        LogSeverity.info => LatexTheme.textSecondary,
      };

  void _navigateToSource(BuildContext context) {
    final files = context.read<ProjectBloc>().state.files;
    final filePath = entry.filePath!;

    // Try exact match, then basename match.
    final hasFile = files.any(
      (f) => f.path == filePath || f.path.endsWith('/$filePath'),
    );

    if (!hasFile) return;

    final matchedPath =
        files.firstWhere(
          (f) => f.path == filePath || f.path.endsWith('/$filePath'),
        ).path;

    context.read<EditorBloc>().add(
      EditorEvent.navigateToLine(
        path: matchedPath,
        line: entry.line!,
      ),
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
