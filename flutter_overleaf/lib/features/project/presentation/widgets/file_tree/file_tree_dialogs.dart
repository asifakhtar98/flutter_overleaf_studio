import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/core/utils/path_utils.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';
import 'package:flutter_overleaf/features/project/presentation/models/tree_node.dart';

class FileTreeDialogs {
  static Future<void> showNewFileDialog(
    BuildContext context, {
    String? parentFolderPath,
  }) async {
    final controller = TextEditingController();
    final prefix = parentFolderPath ?? '';

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          parentFolderPath != null
              ? 'New File in $parentFolderPath/'
              : 'New File',
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'filename.tex',
            prefixText: prefix.isNotEmpty ? prefix : null,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (value) => _createFile(context, ctx, controller, prefix),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _createFile(context, ctx, controller, prefix),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  static Future<void> _createFile(
    BuildContext dialogContext,
    BuildContext dialogCtx,
    TextEditingController controller,
    String prefix,
  ) async {
    final fileName = controller.text.trim();
    if (fileName.isEmpty) return;

    if (!isValidFileName(fileName)) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(
          content: Text(r'Invalid filename: cannot contain < > : | ? * \ /'),
        ),
      );
      return;
    }

    final fullPath = buildFullPath(prefix, fileName);
    final projectBloc = dialogContext.read<ProjectBloc>();
    final exists = projectBloc.state.files.any(
      (ProjectFile f) => f.path == fullPath,
    );
    if (exists) {
      ScaffoldMessenger.of(
        dialogContext,
      ).showSnackBar(SnackBar(content: Text('File already exists: $fullPath')));
      return;
    }

    projectBloc.add(ProjectEvent.addFile(name: fileName, path: fullPath));
    Navigator.of(dialogCtx).pop();
  }

  static Future<void> showNewFolderDialog(
    BuildContext context, {
    String? parentFolderPath,
  }) async {
    final controller = TextEditingController();
    final prefix = parentFolderPath ?? '';

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          parentFolderPath != null
              ? 'New Folder in $parentFolderPath/'
              : 'New Folder',
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'folder name',
            prefixText: prefix.isNotEmpty ? prefix : null,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (value) =>
              _createFolder(context, ctx, controller, prefix),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _createFolder(context, ctx, controller, prefix),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  static Future<void> _createFolder(
    BuildContext dialogContext,
    BuildContext dialogCtx,
    TextEditingController controller,
    String prefix,
  ) async {
    final folderName = controller.text.trim();
    if (folderName.isEmpty) return;

    if (!isValidFolderName(folderName)) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(
          content: Text(r'Invalid folder name: cannot contain < > : | ? * \ /'),
        ),
      );
      return;
    }

    final fullPath = buildFullPath(prefix, folderName);
    final projectBloc = dialogContext.read<ProjectBloc>();
    final exists = projectBloc.state.files.any(
      (ProjectFile f) => f.path == fullPath,
    );
    if (exists) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(content: Text('Folder already exists: $fullPath')),
      );
      return;
    }

    projectBloc.add(ProjectEvent.addFolder(name: folderName, path: fullPath));
    Navigator.of(dialogCtx).pop();
  }

  static Future<void> showRenameDialog(
    BuildContext context,
    TreeNode node,
  ) async {
    final controller = TextEditingController(text: node.name);

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(node.isFolder ? 'Rename Folder' : 'Rename File'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          onSubmitted: (value) => _renameNode(context, ctx, node, controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _renameNode(context, ctx, node, controller),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  static Future<void> _renameNode(
    BuildContext dialogContext,
    BuildContext dialogCtx,
    TreeNode node,
    TextEditingController controller,
  ) async {
    final newName = controller.text.trim();
    if (newName.isEmpty || newName == node.name) {
      Navigator.of(dialogCtx).pop();
      return;
    }

    if (!isValidFileName(newName)) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(
          content: Text(r'Invalid name: cannot contain < > : | ? * \ /'),
        ),
      );
      return;
    }

    final bloc = dialogContext.read<ProjectBloc>();
    if (node.isFolder) {
      bloc.add(ProjectEvent.renameFolder(oldPath: node.path, newName: newName));
    } else {
      bloc.add(ProjectEvent.renameFile(oldPath: node.path, newName: newName));
    }
    Navigator.of(dialogCtx).pop();
  }

  static Future<void> showDeleteConfirmation(
    BuildContext context,
    TreeNode node,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(node.isFolder ? 'Delete Folder?' : 'Delete File?'),
        content: Text(
          node.isFolder
              ? 'Are you sure you want to delete "${node.name}" and all its contents?'
              : 'Are you sure you want to delete "${node.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final bloc = context.read<ProjectBloc>();
              if (node.isFolder) {
                bloc.add(ProjectEvent.deleteFolder(path: node.path));
              } else {
                bloc.add(ProjectEvent.removeFile(path: node.path));
              }
              Navigator.of(ctx).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: LatexTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
