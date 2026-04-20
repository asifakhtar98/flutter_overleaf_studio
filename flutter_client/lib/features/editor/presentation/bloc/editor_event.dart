import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_event.freezed.dart';

@freezed
sealed class EditorEvent with _$EditorEvent {
  const factory EditorEvent.fileOpened({
    required String path,
    required String content,
  }) = FileOpened;

  const factory EditorEvent.contentChanged({required String content}) =
      ContentChanged;

  const factory EditorEvent.tabOpened({
    required String path,
    required String content,
  }) = TabOpened;

  const factory EditorEvent.tabClosed({required String path}) = TabClosed;

  const factory EditorEvent.tabSwitched({
    required String path,
    required String content,
  }) = TabSwitched;
}
