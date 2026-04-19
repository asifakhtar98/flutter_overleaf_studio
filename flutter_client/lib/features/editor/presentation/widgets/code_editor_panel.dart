import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_latex_client/features/editor/presentation/hooks/use_line_count.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_event.dart';

class CodeEditorPanel extends HookWidget {
  const CodeEditorPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final scrollController = useScrollController();
    final lineScrollController = useScrollController();
    final focusNode = useFocusNode();
    final lineCount = useLineCount(controller);

    // Sync editor content when file changes
    final editorBloc = context.watch<EditorBloc>();
    final editorState = editorBloc.state;
    final previousPath = useRef<String?>(null);

    useEffect(
      () {
        if (editorState.activeFilePath != previousPath.value) {
          controller.text = editorState.content;
          previousPath.value = editorState.activeFilePath;
        }
        return null;
      },
      [editorState.activeFilePath],
    );

    // Sync scroll controllers
    useEffect(
      () {
        void onScroll() {
          if (lineScrollController.hasClients) {
            lineScrollController.jumpTo(scrollController.offset);
          }
        }

        scrollController.addListener(onScroll);
        return () => scrollController.removeListener(onScroll);
      },
      [scrollController, lineScrollController],
    );

    return ColoredBox(
      color: LatexTheme.editorBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line numbers gutter
          Container(
            width: 56,
            color: LatexTheme.gutterBg,
            child: ListView.builder(
              controller: lineScrollController,
              padding: const EdgeInsets.only(top: 12, right: 12),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lineCount,
              itemBuilder: (_, index) => SizedBox(
                height: 14 * 1.6,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${index + 1}',
                    style: LatexTheme.monoStyle.copyWith(
                      color: LatexTheme.gutterText,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(width: 1, color: LatexTheme.border),
          // Editor
          Expanded(
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.tab) {
                  final text = controller.text;
                  final selection = controller.selection;
                  final newText =
                      '${text.substring(0, selection.baseOffset)}  '
                      '${text.substring(selection.extentOffset)}';
                  controller.value = TextEditingValue(
                    text: newText,
                    selection: TextSelection.collapsed(
                      offset: selection.baseOffset + 2,
                    ),
                  );
                }
              },
              child: TextField(
                controller: controller,
                scrollController: scrollController,
                focusNode: focusNode,
                maxLines: null,
                expands: true,
                style: LatexTheme.monoStyle,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  isCollapsed: true,
                ),
                onChanged: (value) {
                  context.read<EditorBloc>().add(
                        EditorEvent.contentChanged(
                          content: value,
                        ),
                      );
                  final path =
                      context.read<EditorBloc>().state.activeFilePath;
                  if (path != null) {
                    context.read<ProjectBloc>().add(
                          ProjectEvent.updateFileContent(
                            path: path,
                            content: value,
                          ),
                        );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
