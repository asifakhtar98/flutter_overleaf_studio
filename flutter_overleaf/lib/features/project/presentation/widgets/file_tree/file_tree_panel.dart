import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_state.dart';
import 'package:flutter_overleaf/features/project/presentation/models/tree_node.dart';
import 'package:flutter_overleaf/features/project/presentation/utils/tree_builder.dart';
import 'package:flutter_overleaf/features/project/presentation/widgets/file_tree/file_tree_dialogs.dart';
import 'package:flutter_overleaf/features/project/presentation/widgets/file_tree/tree_node_widget.dart';
import 'package:flutter_overleaf/features/project/presentation/widgets/settings_panel.dart';

class FileTreePanel extends StatelessWidget {
  const FileTreePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final roots = buildTree(state.files);

        return _FileTree(
          roots: roots,
          activeFilePath: state.activeFilePath,
          mainFilePath: state.mainFilePath,
        );
      },
    );
  }
}

class _FileTree extends StatefulWidget {
  const _FileTree({
    required this.roots,
    this.activeFilePath,
    this.mainFilePath,
  });

  final List<TreeNode> roots;
  final String? activeFilePath;
  final String? mainFilePath;

  @override
  State<_FileTree> createState() => _FileTreeState();
}

class _FileTreeState extends State<_FileTree> {
  final Set<String> _expandedFolders = {};

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: LatexTheme.sidebar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with New File + Upload + New Folder buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: LatexTheme.border)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.folder_outlined,
                  size: 16,
                  color: LatexTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'FILES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: LatexTheme.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                _ActionButton(
                  icon: Icons.note_add_outlined,
                  tooltip: 'New File',
                  onTap: () => FileTreeDialogs.showNewFileDialog(context),
                ),
                const SizedBox(width: 4),
                _ActionButton(
                  icon: Icons.upload_file_outlined,
                  tooltip: 'Upload File',
                  onTap: () => FileTreeDialogs.showUploadDialog(context),
                ),
                const SizedBox(width: 4),
                _ActionButton(
                  icon: Icons.create_new_folder_outlined,
                  tooltip: 'New Folder',
                  onTap: () => FileTreeDialogs.showNewFolderDialog(context),
                ),
              ],
            ),
          ),
          // File tree content
          Expanded(
            child: ListView(children: _buildNodeWidgets(widget.roots, 0)),
          ),
          // Settings button at bottom (Overleaf-style)
          const SettingsButton(),
        ],
      ),
    );
  }

  List<Widget> _buildNodeWidgets(List<TreeNode> nodes, int level) {
    final widgets = <Widget>[];
    for (final node in nodes) {
      widgets.add(
        TreeNodeWidget(
          node: node,
          level: level,
          isActive: node.path == widget.activeFilePath,
          isMain: node.path == widget.mainFilePath,
          isExpanded: _expandedFolders.contains(node.path),
          onTap: () => _handleTap(context, node),
          onToggle: () => _toggleFolder(node.path),
          onContextMenu: (pos) => _handleContextMenu(context, node, pos),
        ),
      );

      if (node.isFolder && _expandedFolders.contains(node.path)) {
        widgets.addAll(_buildNodeWidgets(node.children, level + 1));
      }
    }
    return widgets;
  }

  void _toggleFolder(String path) {
    setState(() {
      if (_expandedFolders.contains(path)) {
        _expandedFolders.remove(path);
      } else {
        _expandedFolders.add(path);
      }
    });
  }

  void _handleTap(BuildContext context, TreeNode node) {
    if (node.isFolder) {
      _toggleFolder(node.path);
      return;
    }

    // Fix #2: Flush dirty editor content before switching files.
    final editorState = context.read<EditorBloc>().state;
    if (editorState.currentTabPath != null &&
        editorState.currentTabPath != node.path) {
      context.read<ProjectBloc>().add(
        ProjectEvent.updateFileContent(
          path: editorState.currentTabPath!,
          content: editorState.content,
        ),
      );
    }

    context.read<ProjectBloc>().add(ProjectEvent.selectFile(path: node.path));
    context.read<EditorBloc>().add(
      EditorEvent.tabOpened(path: node.path, content: node.file?.content ?? ''),
    );
  }

  void _handleContextMenu(BuildContext context, TreeNode node, Offset pos) {
    if (node.isFolder) {
      _showFolderContextMenu(context, node, pos);
    } else {
      _showFileContextMenu(context, node, pos);
    }
  }

  Future<void> _showFolderContextMenu(
    BuildContext context,
    TreeNode node,
    Offset globalPosition,
  ) async {
    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        globalPosition.dx + 1,
        globalPosition.dy + 1,
      ),
      items: const [
        PopupMenuItem(value: 'new_file', child: Text('New File')),
        PopupMenuItem(value: 'upload', child: Text('Upload File')),
        PopupMenuItem(value: 'new_folder', child: Text('New Folder')),
        PopupMenuItem(value: 'rename', child: Text('Rename')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );

    if (!context.mounted) return;

    switch (value) {
      case 'new_file':
        await FileTreeDialogs.showNewFileDialog(
          context,
          parentFolderPath: node.path,
        );
      case 'upload':
        await FileTreeDialogs.showUploadDialog(
          context,
          targetFolder: node.path,
        );
      case 'new_folder':
        await FileTreeDialogs.showNewFolderDialog(
          context,
          parentFolderPath: node.path,
        );
      case 'rename':
        await FileTreeDialogs.showRenameDialog(context, node);
      case 'delete':
        await FileTreeDialogs.showDeleteConfirmation(context, node);
    }
  }

  /// Overleaf file context menu: Rename, Delete only.
  /// No "Set as Main" — that's in Settings panel.
  Future<void> _showFileContextMenu(
    BuildContext context,
    TreeNode node,
    Offset globalPosition,
  ) async {
    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        globalPosition.dx + 1,
        globalPosition.dy + 1,
      ),
      items: const [
        PopupMenuItem(value: 'rename', child: Text('Rename')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );

    if (!context.mounted) return;

    switch (value) {
      case 'rename':
        await FileTreeDialogs.showRenameDialog(context, node);
      case 'delete':
        await FileTreeDialogs.showDeleteConfirmation(context, node);
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: LatexTheme.textSecondary),
        ),
      ),
    );
  }
}
