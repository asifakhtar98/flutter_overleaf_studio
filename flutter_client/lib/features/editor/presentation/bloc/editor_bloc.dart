import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_state.dart';

@injectable
class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(const EditorState()) {
    on<FileOpened>(_onFileOpened);
    on<ContentChanged>(_onContentChanged);
  }

  void _onFileOpened(FileOpened event, Emitter<EditorState> emit) {
    emit(
      EditorState(
        content: event.content,
        activeFilePath: event.path,
      ),
    );
  }

  void _onContentChanged(ContentChanged event, Emitter<EditorState> emit) {
    emit(state.copyWith(content: event.content, isDirty: true));
  }
}
