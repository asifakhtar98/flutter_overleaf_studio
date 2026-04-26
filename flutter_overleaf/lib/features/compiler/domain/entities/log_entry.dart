import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_entry.freezed.dart';

/// Severity level of a parsed LaTeX log entry.
enum LogSeverity { error, warning, info }

/// A single parsed entry from a LaTeX compilation log.
@freezed
sealed class LogEntry with _$LogEntry {
  const factory LogEntry({
    required String message,
    required LogSeverity severity,
    String? filePath,
    int? line,
    @Default('') String rawText,
  }) = _LogEntry;
}
