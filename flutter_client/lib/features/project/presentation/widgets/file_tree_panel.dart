import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_latex_client/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_state.dart';

class _TreeNode {
  _TreeNode({required this.name, required this.path, this.file, List<_TreeNode>? children})
      : children = children ?? [];

  final String name;
  final String path;
  final ProjectFile? file;
  final List<_TreeNode> children;

  bool get isFolder => file == null;
}

class FileTreePanel extends HookWidget {
  const FileTreePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final roots = _buildTree(state.files);

        return _FileTree(
          roots: roots,
          activeFilePath: state.activeFilePath,
          mainFilePath: state.mainFilePath,
        );
      },
    );
  }

  List<_TreeNode> _buildTree(List<ProjectFile> files) {
    final rootNodes = <_TreeNode>[];
    final folderMap = <String, _TreeNode>{};

    for (final file in files) {
      final parts = file.path.split('/');
      if (parts.length == 1) {
        rootNodes.add(_TreeNode(name: file.name, path: file.path, file: file));
      } else {
        var currentPath = '';
        var currentChildren = rootNodes;
        for (var i = 0; i < parts.length - 1; i++) {
          currentPath = currentPath.isEmpty ? parts[i] : '$currentPath/${parts[i]}';
          var folder = folderMap[currentPath];
          if (folder == null) {
            folder = _TreeNode(name: parts[i], path: currentPath);
            folderMap[currentPath] = folder;
            currentChildren.add(folder);
          }
          currentChildren = folder.children;
        }
        currentChildren.add(
          _TreeNode(name: file.name, path: file.path, file: file),
        );
      }
    }

    return rootNodes;
  }
}

class _FileTree extends HookWidget {
  const _FileTree({
    required this.roots,
    this.activeFilePath,
    this.mainFilePath,
  });

  final List<_TreeNode> roots;
  final String? activeFilePath;
  final String? mainFilePath;

  @override
  Widget build(BuildContext context) {
    final treeController = useMemoized(
      () => TreeController<_TreeNode>(
        roots: roots,
        childrenProvider: (node) => node.children,
      ),
      [roots],
    );

    useEffect(
      () => treeController.dispose,
      [treeController],
    );

    return ColoredBox(
      color: LatexTheme.sidebar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: LatexTheme.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder_outlined, size: 16, color: LatexTheme.textSecondary),
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
                  onTap: () => _showNewFileDialog(context),
                ),
              ],
            ),
          ),
          // Tree
          Expanded(
            child: AnimatedTreeView<_TreeNode>(
              treeController: treeController,
              nodeBuilder: (context, entry) {
                final node = entry.node;
                final isActive = node.path == activeFilePath;
                final isMain = node.path == mainFilePath;

                return InkWell(
                  onTap: () {
                    if (node.isFolder) {
                      treeController.toggleExpansion(node);
                    } else {
                      context.read<ProjectBloc>().add(
                            ProjectEvent.selectFile(path: node.path),
                          );
                      context.read<EditorBloc>().add(
                            EditorEvent.fileOpened(
                              path: node.path,
                              content: node.file?.content ?? '',
                            ),
                          );
                    }
                  },
                  onSecondaryTap: node.file != null
                      ? () => _showContextMenu(context, node)
                      : null,
                  child: Container(
                    color: isActive
                        ? LatexTheme.primaryLight
                        : Colors.transparent,
                    padding: EdgeInsets.only(
                      left: 12.0 + entry.level * 16.0,
                      right: 12,
                      top: 6,
                      bottom: 6,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          node.isFolder
                              ? (entry.isExpanded
                                  ? Icons.folder_open
                                  : Icons.folder)
                              : _fileIcon(node.name),
                          size: 16,
                          color: node.isFolder
                              ? const Color(0xFFF59E0B)
                              : LatexTheme.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            node.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: LatexTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isMain)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: LatexTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'main',
                              style: TextStyle(
                                fontSize: 10,
                                color: LatexTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _fileIcon(String name) {
    if (name.endsWith('.tex')) return Icons.description_outlined;
    if (name.endsWith('.bib')) return Icons.menu_book_outlined;
    if (name.endsWith('.sty') || name.endsWith('.cls')) {
      return Icons.settings_outlined;
    }
    if (name.endsWith('.png') || name.endsWith('.jpg') || name.endsWith('.pdf')) {
      return Icons.image_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  void _showNewFileDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New File'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'filename.tex',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              context.read<ProjectBloc>().add(
                    ProjectEvent.addFile(
                      name: value.trim(),
                      path: value.trim(),
                    ),
                  );
              Navigator.of(ctx).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                context.read<ProjectBloc>().add(
                      ProjectEvent.addFile(name: value, path: value),
                    );
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _showContextMenu(
    BuildContext context,
    _TreeNode node,
  ) async {
    final bloc = context.read<ProjectBloc>();
    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fill,
      items: [
        const PopupMenuItem(
          value: 'main',
          child: Text('Set as Main'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    );
    if (value == 'main') {
      bloc.add(ProjectEvent.setMainFile(path: node.path));
    } else if (value == 'delete') {
      bloc.add(ProjectEvent.removeFile(path: node.path));
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
