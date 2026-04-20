import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';
import 'package:flutter_latex_client/features/project/presentation/models/tree_node.dart';

List<TreeNode> buildTree(List<ProjectFile> files) {
  final rootNodes = <TreeNode>[];
  final folderMap = <String, TreeNode>{};

  for (final file in files) {
    final parts = file.path.split('/');
    if (parts.length == 1) {
      rootNodes.add(TreeNode(name: parts.last, path: file.path, file: file));
    } else {
      var currentPath = '';
      var currentChildren = rootNodes;
      for (var i = 0; i < parts.length - 1; i++) {
        currentPath = currentPath.isEmpty
            ? parts[i]
            : '$currentPath/${parts[i]}';
        var folder = folderMap[currentPath];
        if (folder == null) {
          folder = TreeNode(name: parts[i], path: currentPath);
          folderMap[currentPath] = folder;
          currentChildren.add(folder);
        }
        currentChildren = folder.children;
      }
      currentChildren.add(
        TreeNode(name: parts.last, path: file.path, file: file),
      );
    }
  }

  return rootNodes;
}
