import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_event.freezed.dart';

@freezed
sealed class ProjectEvent with _$ProjectEvent {
  const factory ProjectEvent.addFile({
    required String name,
    required String path,
    @Default('') String content,
  }) = AddFile;

  const factory ProjectEvent.removeFile({
    required String path,
  }) = RemoveFile;

  const factory ProjectEvent.renameFile({
    required String oldPath,
    required String newName,
  }) = RenameFile;

  const factory ProjectEvent.selectFile({
    required String path,
  }) = SelectFile;

  const factory ProjectEvent.updateFileContent({
    required String path,
    required String content,
  }) = UpdateFileContent;

  const factory ProjectEvent.setMainFile({
    required String path,
  }) = SetMainFile;

  const factory ProjectEvent.addFolder({
    required String name,
    required String path,
  }) = AddFolder;

  const factory ProjectEvent.toggleFolder({
    required String path,
  }) = ToggleFolder;
}
