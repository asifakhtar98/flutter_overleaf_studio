import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_monaco/flutter_monaco.dart' as monaco;
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_state.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_event.dart';

class CodeEditorPanel extends HookWidget {
  const CodeEditorPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        if (state.openTabs.isEmpty) {
          return const _EmptyState();
        }

        return Column(
          children: [
            _TabsBar(
              openTabs: state.openTabs,
              currentTabPath: state.currentTabPath,
              isDirty: state.isDirty,
            ),
            Expanded(
              child: monaco.MonacoEditor(
                initialValue: state.content,
                options: const monaco.EditorOptions(
                  language: monaco.MonacoLanguage.plaintext,
                  theme: monaco.MonacoTheme.vsDark,
                  fontSize: 13,
                  fontFamily: 'JetBrains Mono, Consolas, monospace',
                  lineNumbers: true,
                  minimap: false,
                  wordWrap: true,
                  tabSize: 2,
                ),
                onContentChanged: (value) {
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
              context.read<EditorBloc>().add(
                EditorEvent.tabSwitched(path: path),
              );
            },
            onClose: () {
              if (isActive && isDirty) {
                _showCloseConfirmation(context, path);
              } else {
                context.read<EditorBloc>().add(
                  EditorEvent.tabClosed(path: path),
                );
              }
            },
          );
        },
      ),
    );
  }

  void _showCloseConfirmation(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close tab?'),
        content: const Text('You have unsaved changes. Close anyway?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<EditorBloc>().add(EditorEvent.tabClosed(path: path));
              Navigator.of(ctx).pop();
            },
            child: const Text('Close'),
          ),
        ],
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
