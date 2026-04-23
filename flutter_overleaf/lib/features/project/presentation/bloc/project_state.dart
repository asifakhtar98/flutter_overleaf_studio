import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_overleaf/core/models/engine.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';

part 'project_state.freezed.dart';
part 'project_state.g.dart';

@freezed
sealed class ProjectState with _$ProjectState {
  const factory ProjectState({
    @Default([]) List<ProjectFile> files,
    String? activeFilePath,
    String? mainFilePath,
    @Default(Engine.pdflatex) Engine engine,
    @Default(false) bool draftMode,
    @Default(true) bool enableCache,
    @Default(false) bool isImporting,
    @Default(false) bool isExporting,
    String? importError,
  }) = _ProjectState;

  factory ProjectState.fromJson(Map<String, dynamic> json) =>
      _$ProjectStateFromJson(json);
}
