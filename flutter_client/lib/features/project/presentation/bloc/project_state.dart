import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';

part 'project_state.freezed.dart';
part 'project_state.g.dart';

@freezed
sealed class ProjectState with _$ProjectState {
  const factory ProjectState({
    @Default([]) List<ProjectFile> files,
    String? activeFilePath,
    String? mainFilePath,
    @Default('pdflatex') String engine,
    @Default(false) bool draftMode,
    @Default(false) bool isImporting,
    @Default(false) bool isExporting,
    String? importError,
  }) = _ProjectState;

  factory ProjectState.fromJson(Map<String, dynamic> json) =>
      _$ProjectStateFromJson(json);
}
