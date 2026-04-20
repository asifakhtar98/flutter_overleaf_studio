import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_state.dart';

@injectable
class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(const EditorState()) {
    on<FileOpened>(_onFileOpened);
    on<ContentChanged>(_onContentChanged);
    on<TabOpened>(_onTabOpened);
    on<TabClosed>(_onTabClosed);
    on<TabSwitched>(_onTabSwitched);
  }

  void _onFileOpened(FileOpened event, Emitter<EditorState> emit) {
    final newTabs = state.openTabs.contains(event.path)
        ? state.openTabs
        : [...state.openTabs, event.path];
    emit(
      EditorState(
        content: event.content,
        openTabs: newTabs,
        currentTabPath: event.path,
      ),
    );
  }

  void _onContentChanged(ContentChanged event, Emitter<EditorState> emit) {
    emit(state.copyWith(content: event.content));
  }

  void _onTabOpened(TabOpened event, Emitter<EditorState> emit) {
    final newTabs = state.openTabs.contains(event.path)
        ? state.openTabs
        : [...state.openTabs, event.path];
    emit(
      state.copyWith(
        content: event.content,
        openTabs: newTabs,
        currentTabPath: event.path,
      ),
    );
  }

  void _onTabClosed(TabClosed event, Emitter<EditorState> emit) {
    final newTabs = state.openTabs.where((p) => p != event.path).toList();

    if (state.currentTabPath != event.path) {
      emit(state.copyWith(openTabs: newTabs));
      return;
    }

    // Active tab was closed — pick replacement but don't load content here.
    // The UI layer (BlocListener) handles loading replacement content.
    final newCurrentTab = newTabs.isNotEmpty ? newTabs.last : null;
    emit(
      state.copyWith(
        openTabs: newTabs,
        currentTabPath: newCurrentTab,
        content: '',
      ),
    );
  }

  void _onTabSwitched(TabSwitched event, Emitter<EditorState> emit) {
    if (state.openTabs.contains(event.path)) {
      emit(state.copyWith(currentTabPath: event.path, content: event.content));
    }
  }
}
