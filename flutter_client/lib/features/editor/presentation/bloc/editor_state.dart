import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_state.freezed.dart';

@freezed
sealed class EditorState with _$EditorState {
  const factory EditorState({
    @Default('') String content,
    @Default([]) List<String> openTabs,
    String? currentTabPath,
  }) = _EditorState;
}
