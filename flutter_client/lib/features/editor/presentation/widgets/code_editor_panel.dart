import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:highlight/languages/tex.dart';

import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_state.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_event.dart';

class CodeEditorPanel extends StatefulWidget {
  const CodeEditorPanel({super.key});

  @override
  State<CodeEditorPanel> createState() => _CodeEditorPanelState();
}

class _CodeEditorPanelState extends State<CodeEditorPanel> {
  late CodeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CodeController(
      text: '',
      language: tex,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncContent(BuildContext context, String newContent) {
    if (_controller.text != newContent) {
      _controller.text = newContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        if (state.openTabs.isEmpty) {
          return const _EmptyState();
        }

        _syncContent(context, state.content);

        return Column(
          children: [
            _TabsBar(
              openTabs: state.openTabs,
              currentTabPath: state.currentTabPath,
              isDirty: state.isDirty,
            ),
            Expanded(
              child: CodeTheme(
                data: CodeThemeData(styles: vs2015Theme),
                child: CodeField(
                  controller: _controller,
                  textStyle: const TextStyle(
                    fontFamily: 'JetBrains Mono, Consolas, monospace',
                    fontSize: 13,
                  ),
                  gutterStyle: const GutterStyle(
                    showLineNumbers: true,
                    showFoldingHandles: true,
                  ),
                  wrap: true,
                  onChanged: (value) {
                    context.read<EditorBloc>().add(
                      EditorEvent.contentChanged(content: value),
                    );
                    final path = context.read<EditorBloc>().state.activeFilePath;
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
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: LatexTheme.editorBg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_note,
              size: 48,
              color: LatexTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Create or import a project to get started',
              style: TextStyle(
                fontSize: 14,
                color: LatexTheme.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabsBar extends StatelessWidget {
  const _TabsBar({
    required this.openTabs,
    required this.currentTabPath,
    required this.isDirty,
  });

  final List<String> openTabs;
  final String? currentTabPath;
  final bool isDirty;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: LatexTheme.gutterBg,
        border: Border(bottom: BorderSide(color: LatexTheme.border)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: openTabs.length,
        itemBuilder: (context, index) {
          final path = openTabs[index];
          final isActive = path == currentTabPath;
          final fileName = path.split('/').last;

          return _Tab(
            label: fileName,
            isActive: isActive,
            isDirty: isActive && isDirty,
            onTap: () {
              final projectFiles = context.read<ProjectBloc>().state.files;
              final targetFile = projectFiles.where((f) => f.path == path).firstOrNull;
              final content = targetFile?.content ?? '';
              context.read<EditorBloc>().add(
                EditorEvent.tabSwitched(path: path, content: content),
              );
            },
            onClose: () {
              context.read<EditorBloc>().add(
                EditorEvent.tabClosed(path: path),
              );
            },
          );
        },
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.isActive,
    required this.isDirty,
    required this.onTap,
    required this.onClose,
  });

  final String label;
  final bool isActive;
  final bool isDirty;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? LatexTheme.editorBg : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isActive ? LatexTheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDirty)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: const BoxDecoration(
                  color: LatexTheme.warning,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? LatexTheme.textPrimary
                    : LatexTheme.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(
                  Icons.close,
                  size: 12,
                  color: LatexTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
