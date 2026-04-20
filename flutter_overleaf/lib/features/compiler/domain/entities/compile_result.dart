import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'compile_result.freezed.dart';

@freezed
sealed class CompileResult with _$CompileResult {
  const factory CompileResult({
    required Uint8List pdfBytes,
    required String log,
    required double compilationTime,
    required String engine,
    required int warningsCount,
    required int passesRun,
    required bool cached,
  }) = _CompileResult;
}
