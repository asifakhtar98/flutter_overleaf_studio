import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';

import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/compiler/presentation/widgets/pdf_viewer_panel.dart';
import 'package:flutter_latex_client/features/editor/presentation/widgets/code_editor_panel.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_latex_client/features/project/presentation/widgets/file_tree/file_tree_panel.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return const _DesktopLayout();
        }
        return const _MobileLayout();
      },
    );
  }
}

class _DesktopLayout extends StatefulWidget {
  const _DesktopLayout();

  @override
  State<_DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<_DesktopLayout> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) => _handleDroppedFiles(context, detail.files),
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      child: Stack(
        children: [
          MultiSplitViewTheme(
            data: MultiSplitViewThemeData(
              dividerThickness: 5,
              dividerPainter: DividerPainters.grooved1(
                color: LatexTheme.textSecondary.withValues(alpha: 0.3),
                highlightedColor: LatexTheme.primary.withValues(alpha: 0.5),
              ),
            ),
            child: MultiSplitView(
              initialAreas: [
                Area(size: 220, min: 150, data: 'file_tree'),
                Area(flex: 1, min: 300, data: 'editor'),
                Area(flex: 1, min: 300, data: 'pdf'),
              ],
              builder: (context, area) {
                return switch (area.data as String) {
                  'file_tree' => const FileTreePanel(),
                  'editor' => const CodeEditorPanel(),
                  'pdf' => const PdfViewerPanel(),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
          if (_isDragging)
            ColoredBox(
              color: LatexTheme.primary.withValues(alpha: 0.1),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: LatexTheme.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: LatexTheme.primary, width: 2),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        size: 48,
                        color: LatexTheme.primary,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Drop .tex or .zip file here',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: LatexTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleDroppedFiles(
    BuildContext context,
    List<XFile> files,
  ) async {
    final bloc = context.read<ProjectBloc>();

    for (final xFile in files) {
      final path = xFile.path;
      final fileName = path.split(Platform.pathSeparator).last;

      if (fileName.endsWith('.zip')) {
        bloc.add(const ProjectEvent.importProject());
      } else if (fileName.endsWith('.tex')) {
        final content = await File(path).readAsString();
        bloc.add(
          ProjectEvent.addFile(
            name: fileName,
            path: fileName,
            content: content,
          ),
        );
      }
    }
  }
}

class _MobileLayout extends HookWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    final tabIndex = useState(0);

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: LatexTheme.background,
            border: Border(bottom: BorderSide(color: LatexTheme.border)),
          ),
          child: Row(
            children: [
              _Tab(
                label: 'Editor',
                icon: Icons.edit_note,
                isSelected: tabIndex.value == 0,
                onTap: () => tabIndex.value = 0,
              ),
              _Tab(
                label: 'Preview',
                icon: Icons.picture_as_pdf,
                isSelected: tabIndex.value == 1,
                onTap: () => tabIndex.value = 1,
              ),
            ],
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: tabIndex.value,
            children: const [CodeEditorPanel(), PdfViewerPanel()],
          ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? LatexTheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? LatexTheme.primary
                    : LatexTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? LatexTheme.primary
                      : LatexTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
