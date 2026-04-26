import 'package:flutter_overleaf/features/compiler/domain/entities/log_entry.dart';

/// Regex patterns pre-compiled at module level per AGENTS.md rules.

/// Matches: `./main.tex:42: Undefined control sequence`
final _fileLineError = RegExp(r'^\./?([\w/.\-]+):(\d+):\s*(.+)$');

/// Matches: `! Undefined control sequence.`
final _bangError = RegExp(r'^!\s*(.+)$');

/// Matches: `l.42 \badcommand`
final _lineRef = RegExp(r'^l\.(\d+)\s+(.*)$');

/// Matches: `LaTeX Warning: ...` or `Package hyperref Warning: ...`
final _latexWarning = RegExp(
  r'(?:LaTeX|Package \w+) Warning:\s*(.+?)(?:\.|$)',
);

/// Matches: `Overfull \hbox ...` or `Underfull \vbox ...`
final _badBox = RegExp(r'^((?:Over|Under)full \\[hv]box .+)$');

/// Parses a raw LaTeX compilation log into structured [LogEntry] items.
///
/// Entries are returned with errors first, then warnings, then info.
/// Duplicate entries (same file + line + message) are removed.
List<LogEntry> parseLatexLog(String log) {
  if (log.isEmpty) return const [];

  final entries = <LogEntry>[];
  final lines = log.split('\n');
  final seen = <String>{};

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];

    // 1. File:line:message errors (highest priority)
    final fileMatch = _fileLineError.firstMatch(line);
    if (fileMatch != null) {
      _addUnique(
        entries,
        seen,
        LogEntry(
          filePath: fileMatch.group(1),
          line: int.tryParse(fileMatch.group(2) ?? ''),
          message: fileMatch.group(3)?.trim() ?? '',
          severity: LogSeverity.error,
          rawText: line,
        ),
      );
      continue;
    }

    // 2. Bang errors (! Error message)
    final bangMatch = _bangError.firstMatch(line);
    if (bangMatch != null) {
      // Look ahead for l.N to get the line number
      int? errorLine;
      String? errorContext;
      for (var j = i + 1; j < lines.length && j <= i + 5; j++) {
        final refMatch = _lineRef.firstMatch(lines[j]);
        if (refMatch != null) {
          errorLine = int.tryParse(refMatch.group(1) ?? '');
          errorContext = refMatch.group(2);
          break;
        }
      }
      _addUnique(
        entries,
        seen,
        LogEntry(
          message: bangMatch.group(1)?.trim() ?? '',
          severity: LogSeverity.error,
          line: errorLine,
          rawText: errorContext != null ? '$line\nl.$errorLine $errorContext' : line,
        ),
      );
      continue;
    }

    // 3. LaTeX / Package warnings
    final warnMatch = _latexWarning.firstMatch(line);
    if (warnMatch != null) {
      _addUnique(
        entries,
        seen,
        LogEntry(
          message: warnMatch.group(1)?.trim() ?? '',
          severity: LogSeverity.warning,
          rawText: line,
        ),
      );
      continue;
    }

    // 4. Overfull / Underfull box warnings
    final boxMatch = _badBox.firstMatch(line);
    if (boxMatch != null) {
      _addUnique(
        entries,
        seen,
        LogEntry(
          message: boxMatch.group(1)?.trim() ?? '',
          severity: LogSeverity.warning,
          rawText: line,
        ),
      );
    }
  }

  // Sort: errors first, then warnings, then info.
  entries.sort((a, b) => a.severity.index.compareTo(b.severity.index));
  return entries;
}

/// Adds an entry only if its (file, line, message) key hasn't been seen.
void _addUnique(
  List<LogEntry> entries,
  Set<String> seen,
  LogEntry entry,
) {
  final key = '${entry.filePath}:${entry.line}:${entry.message}';
  if (seen.add(key)) {
    entries.add(entry);
  }
}
