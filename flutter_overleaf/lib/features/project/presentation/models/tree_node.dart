import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';

class TreeNode {
  TreeNode({
    required this.name,
    required this.path,
    this.file,
    List<TreeNode>? children,
  }) : children = children ?? [];

  final String name;
  final String path;
  final ProjectFile? file;
  final List<TreeNode> children;

  bool get isFolder => file == null;
}
