import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';

part 'project_event.freezed.dart';

@freezed
sealed class ProjectEvent with _$ProjectEvent {
  const factory ProjectEvent.addFile({
    required String name,
    required String path,
    @Default('') String content,
  }) = AddFile;

  const factory ProjectEvent.removeFile({required String path}) = RemoveFile;

  const factory ProjectEvent.renameFile({
    required String oldPath,
    required String newName,
  }) = RenameFile;

  const factory ProjectEvent.selectFile({required String path}) = SelectFile;

  const factory ProjectEvent.updateFileContent({
    required String path,
    required String content,
  }) = UpdateFileContent;

  const factory ProjectEvent.setMainFile({required String path}) = SetMainFile;

  const factory ProjectEvent.setEngine({required String engine}) = SetEngine;

  const factory ProjectEvent.setDraftMode({required bool draft}) = SetDraftMode;

  const factory ProjectEvent.addFolder({
    required String name,
    required String path,
  }) = AddFolder;

  const factory ProjectEvent.renameFolder({
    required String oldPath,
    required String newName,
  }) = RenameFolder;

  const factory ProjectEvent.deleteFolder({required String path}) =
      DeleteFolder;

  const factory ProjectEvent.importProject({List<int>? bytes}) =
      ImportProjectEvent;

  const factory ProjectEvent.exportProject() = ExportProjectEvent;

  const factory ProjectEvent.loadFiles({
    required List<ProjectFile> files,
    String? activeFilePath,
    String? mainFilePath,
  }) = LoadFiles;
}
