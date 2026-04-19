import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_file.freezed.dart';
part 'project_file.g.dart';

@freezed
sealed class ProjectFile with _$ProjectFile {
  const factory ProjectFile({
    required String name,
    required String path,
    required String content,
    @Default(false) bool isMainFile,
  }) = _ProjectFile;

  factory ProjectFile.fromJson(Map<String, dynamic> json) =>
      _$ProjectFileFromJson(json);
}

@freezed
sealed class ProjectNode with _$ProjectNode {
  const factory ProjectNode.file({
    required ProjectFile file,
  }) = ProjectFileNode;

  const factory ProjectNode.folder({
    required String name,
    required String path,
    @Default([]) List<ProjectNode> children,
    @Default(false) bool isExpanded,
  }) = ProjectFolderNode;

  factory ProjectNode.fromJson(Map<String, dynamic> json) =>
      _$ProjectNodeFromJson(json);
}
