import 'package:flutter/material.dart';

import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/project/presentation/models/tree_node.dart';

class TreeNodeWidget extends StatefulWidget {
  const TreeNodeWidget({
    required this.node,
    required this.level,
    required this.isActive,
    required this.isMain,
    required this.isExpanded,
    required this.onTap,
    required this.onToggle,
    required this.onContextMenu,
    super.key,
  });

  final TreeNode node;
  final int level;
  final bool isActive;
  final bool isMain;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final void Function(Offset) onContextMenu;

  @override
  State<TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<TreeNodeWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onSecondaryTapDown: (details) =>
            widget.onContextMenu(details.globalPosition),
        onLongPressStart: (details) =>
            widget.onContextMenu(details.globalPosition),
        child: InkWell(
          onTap: widget.node.isFolder ? widget.onToggle : widget.onTap,
          child: Container(
            color: widget.isActive
                ? LatexTheme.primaryLight
                : Colors.transparent,
            padding: EdgeInsets.only(
              left: 12.0 + widget.level * 16.0,
              right: 12,
              top: 6,
              bottom: 6,
            ),
            child: Row(
              children: [
                if (widget.node.isFolder)
                  Icon(
                    widget.isExpanded ? Icons.expand_more : Icons.chevron_right,
                    size: 16,
                    color: LatexTheme.textSecondary,
                  ),
                Icon(
                  widget.node.isFolder
                      ? (widget.isExpanded ? Icons.folder_open : Icons.folder)
                      : _fileIcon(widget.node.name),
                  size: 16,
                  color: widget.node.isFolder
                      ? const Color(0xFFF59E0B)
                      : LatexTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.node.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: widget.isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: LatexTheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.isMain)
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
                if (_isHovered)
                  GestureDetector(
                    onTap: () {
                      final box = context.findRenderObject()! as RenderBox;
                      final pos = box.localToGlobal(
                        Offset(box.size.width, box.size.height / 2),
                      );
                      widget.onContextMenu(pos);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.more_vert,
                        size: 14,
                        color: LatexTheme.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _fileIcon(String name) {
    if (name.endsWith('.tex')) return Icons.description_outlined;
    if (name.endsWith('.bib')) return Icons.menu_book_outlined;
    if (name.endsWith('.sty') || name.endsWith('.cls')) {
      return Icons.settings_outlined;
    }
    if (name.endsWith('.png') ||
        name.endsWith('.jpg') ||
        name.endsWith('.pdf')) {
      return Icons.image_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }
}
