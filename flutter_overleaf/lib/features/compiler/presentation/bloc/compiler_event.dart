import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_overleaf/core/models/engine.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';

part 'compiler_event.freezed.dart';

@freezed
sealed class CompilerEvent with _$CompilerEvent {
  const factory CompilerEvent.compileRequested({
    required Engine engine,
    required bool draft,
    required List<ProjectFile> files,
    required String mainFile,
    @Default(true) bool enableCache,
  }) = CompileRequested;

  const factory CompilerEvent.reset() = CompileReset;
}
