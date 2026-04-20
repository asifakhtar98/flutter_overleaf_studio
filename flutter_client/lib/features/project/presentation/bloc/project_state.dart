import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';

part 'project_state.freezed.dart';
part 'project_state.g.dart';

@freezed
sealed class ProjectFolder with _$ProjectFolder {
  const factory ProjectFolder({
    required String name,
    required String path,
    @Default([]) List<ProjectFolder> children,
    @Default(true) bool isExpanded,
  }) = _ProjectFolder;

  factory ProjectFolder.fromJson(Map<String, dynamic> json) =>
      _$ProjectFolderFromJson(json);
}

@freezed
sealed class ProjectState with _$ProjectState {
  const factory ProjectState({
    @Default([]) List<ProjectFile> files,
    @Default([]) List<ProjectFolder> folders,
    String? activeFilePath,
    String? mainFilePath,
  }) = _ProjectState;

  factory ProjectState.fromJson(Map<String, dynamic> json) =>
      _$ProjectStateFromJson(json);
}
