import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_state.freezed.dart';

@freezed
sealed class EditorState with _$EditorState {
  const factory EditorState({
    @Default('') String content,
    String? activeFilePath,
    @Default([]) List<String> openTabs,
    String? currentTabPath,
    @Default(false) bool isDirty,
    @Default(false) bool isSaving,
    DateTime? lastSaved,
  }) = _EditorState;
}
