import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:highlight/languages/tex.dart';

import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_state.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_event.dart';

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
    _controller = CodeController(text: '', language: tex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncContent(String newContent) {
    if (_controller.text != newContent) {
      _controller.text = newContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // RC2: Listen for tab path changes (including tab close) to load
        // content from the project state.
        BlocListener<EditorBloc, EditorState>(
          listenWhen: (prev, curr) =>
              prev.currentTabPath != curr.currentTabPath,
          listener: (context, editorState) {
            final newPath = editorState.currentTabPath;
            if (newPath == null) return;

            // If content is already loaded (e.g. from tabSwitched), skip.
            if (editorState.content.isNotEmpty) return;

            // Load content from project state for the new tab.
            final projectFiles = context.read<ProjectBloc>().state.files;
            final file =
                projectFiles.where((f) => f.path == newPath).firstOrNull;
            if (file != null) {
              context.read<EditorBloc>().add(
                EditorEvent.tabSwitched(
                  path: newPath,
                  content: file.content,
                ),
              );
            }
          },
        ),
        // Fix #1: Sync controller when content changes programmatically
        // (e.g. after tab-close picks a replacement and tabSwitched loads
        // its content). No-op for user keystrokes because
        // _controller.text already matches.
        BlocListener<EditorBloc, EditorState>(
          listenWhen: (prev, curr) =>
              prev.content != curr.content &&
              prev.currentTabPath == curr.currentTabPath,
          listener: (context, state) => _syncContent(state.content),
        ),
      ],
      child: BlocBuilder<EditorBloc, EditorState>(
        // RC1: Only rebuild when the file changes or tabs change,
        // NOT on every content keystroke.
        buildWhen: (prev, curr) =>
            prev.currentTabPath != curr.currentTabPath ||
            prev.openTabs != curr.openTabs,
        builder: (context, state) {
          if (state.openTabs.isEmpty) {
            return const _EmptyState();
          }

          _syncContent(state.content);

          final projectFiles = context.read<ProjectBloc>().state.files;
          final currentFile = projectFiles
              .where((f) => f.path == state.currentTabPath)
              .firstOrNull;
          final isBinary = currentFile?.isBinary ?? false;

          return Column(
            children: [
              _TabsBar(
                openTabs: state.openTabs,
                currentTabPath: state.currentTabPath,
              ),
              Expanded(
                child: isBinary
                    ? _BinaryPreview(file: currentFile!)
                    : _buildCodeEditor(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCodeEditor(BuildContext context) {
    return CodeTheme(
      data: CodeThemeData(styles: vs2015Theme),
      child: CodeField(
        controller: _controller,
        expands: true,
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
          final path = context
              .read<EditorBloc>()
              .state
              .currentTabPath;
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
  const _TabsBar({required this.openTabs, required this.currentTabPath});

  final List<String> openTabs;
  final String? currentTabPath;

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
            onTap: () {
              // Fix #2: Flush dirty content before switching tabs.
              final editorState = context.read<EditorBloc>().state;
              if (editorState.currentTabPath != null &&
                  editorState.currentTabPath != path) {
                context.read<ProjectBloc>().add(
                  ProjectEvent.updateFileContent(
                    path: editorState.currentTabPath!,
                    content: editorState.content,
                  ),
                );
              }

              final projectFiles = context.read<ProjectBloc>().state.files;
              final targetFile = projectFiles
                  .where((f) => f.path == path)
                  .firstOrNull;
              final content = targetFile?.content ?? '';
              context.read<EditorBloc>().add(
                EditorEvent.tabSwitched(path: path, content: content),
              );
            },
            onClose: () {
              context.read<EditorBloc>().add(EditorEvent.tabClosed(path: path));
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
    required this.onTap,
    required this.onClose,
  });

  final String label;
  final bool isActive;
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

/// Displays a binary file preview. Shows an image for supported formats,
/// or a generic file icon with file info for other binary types.
class _BinaryPreview extends StatelessWidget {
  const _BinaryPreview({required this.file});

  final ProjectFile file;

  static const _imageExtensions = {'.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp'};

  bool get _isImage {
    final lower = file.path.toLowerCase();
    return _imageExtensions.any(lower.endsWith);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: LatexTheme.editorBg,
      child: Center(
        child: _isImage && file.binaryContentBase64 != null
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Image.memory(
                  base64Decode(file.binaryContentBase64!),
                  fit: BoxFit.contain,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.insert_drive_file_outlined,
                    size: 64,
                    color: LatexTheme.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    file.name,
                    style: const TextStyle(
                      color: LatexTheme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Binary file — no editor preview',
                    style: TextStyle(
                      color: LatexTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
