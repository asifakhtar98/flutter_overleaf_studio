import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_state.dart';

void main() {
  group('EditorBloc', () {
    late EditorBloc bloc;

    setUp(() => bloc = EditorBloc());
    tearDown(() => bloc.close());

    test('initial state has no tabs', () {
      expect(bloc.state, const EditorState());
      expect(bloc.state.openTabs, isEmpty);
      expect(bloc.state.currentTabPath, isNull);
    });

    blocTest<EditorBloc, EditorState>(
      'fileOpened adds tab and sets content',
      build: EditorBloc.new,
      act: (b) => b.add(
        const EditorEvent.fileOpened(path: 'main.tex', content: r'\hello'),
      ),
      expect: () => [
        isA<EditorState>()
            .having((s) => s.openTabs, 'openTabs', ['main.tex'])
            .having((s) => s.currentTabPath, 'currentTabPath', 'main.tex')
            .having((s) => s.content, 'content', r'\hello'),
      ],
    );

    blocTest<EditorBloc, EditorState>(
      'contentChanged updates content without changing tabs',
      build: EditorBloc.new,
      seed: () => const EditorState(
        openTabs: ['main.tex'],
        currentTabPath: 'main.tex',
        content: '',
      ),
      act: (b) => b.add(
        const EditorEvent.contentChanged(content: 'new content'),
      ),
      expect: () => [
        isA<EditorState>()
            .having((s) => s.content, 'content', 'new content')
            .having((s) => s.openTabs, 'openTabs', ['main.tex']),
      ],
    );

    blocTest<EditorBloc, EditorState>(
      'tabClosed removes tab and selects adjacent',
      build: EditorBloc.new,
      seed: () => const EditorState(
        openTabs: ['a.tex', 'b.tex'],
        currentTabPath: 'b.tex',
        content: 'b content',
      ),
      act: (b) => b.add(const EditorEvent.tabClosed(path: 'b.tex')),
      expect: () => [
        isA<EditorState>()
            .having((s) => s.openTabs, 'openTabs', ['a.tex'])
            .having((s) => s.currentTabPath, 'currentTabPath', 'a.tex'),
      ],
    );

    blocTest<EditorBloc, EditorState>(
      'closing last tab results in empty state',
      build: EditorBloc.new,
      seed: () => const EditorState(
        openTabs: ['only.tex'],
        currentTabPath: 'only.tex',
        content: 'some',
      ),
      act: (b) => b.add(const EditorEvent.tabClosed(path: 'only.tex')),
      expect: () => [
        isA<EditorState>()
            .having((s) => s.openTabs, 'openTabs', isEmpty)
            .having((s) => s.currentTabPath, 'currentTabPath', isNull),
      ],
    );
  });
}
