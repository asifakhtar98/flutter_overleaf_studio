import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_overleaf/core/di/injection.dart';
import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_state.dart';

/// Overleaf-style settings panel: gear icon at bottom of sidebar.
/// Opens a bottom sheet with Main Document dropdown + Compiler selector.
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: LatexTheme.border)),
      ),
      child: Row(
        children: [
          // Talker Logs
          Tooltip(
            message: 'View App Logs',
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => TalkerScreen(talker: getIt<Talker>()),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.receipt_long,
                  size: 16,
                  color: LatexTheme.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Import Button
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              if (state.isImporting) {
                return const Padding(
                  padding: EdgeInsets.all(4),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: LatexTheme.textSecondary,
                    ),
                  ),
                );
              }
              return Tooltip(
                message: 'Import ZIP project',
                child: InkWell(
                  onTap: () => context.read<ProjectBloc>().add(
                    const ProjectEvent.importProject(),
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.folder_open_outlined,
                      size: 16,
                      color: LatexTheme.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 4),

          // Export Button
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              if (state.isExporting) {
                return const Padding(
                  padding: EdgeInsets.all(4),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: LatexTheme.textSecondary,
                    ),
                  ),
                );
              }
              return Tooltip(
                message: 'Export as ZIP',
                child: InkWell(
                  onTap: () => context.read<ProjectBloc>().add(
                    const ProjectEvent.exportProject(),
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.save_alt_outlined,
                      size: 16,
                      color: LatexTheme.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),

          const Spacer(),

          // Settings Button
          Tooltip(
            message: 'Project Settings',
            child: InkWell(
              onTap: () => _showSettingsPanel(context),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.settings_outlined,
                  size: 16,
                  color: LatexTheme.textSecondary,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 8),

          // Draft mode toggle
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              return Tooltip(
                message: 'Draft mode — skips images',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Draft',
                      style: TextStyle(
                        fontSize: 11,
                        color: LatexTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 2),
                    SizedBox(
                      height: 20,
                      width: 28,
                      child: Transform.scale(
                        scale: 0.65,
                        child: Switch(
                          value: state.draftMode,
                          onChanged: (v) {
                            context.read<ProjectBloc>().add(
                              ProjectEvent.setDraftMode(draft: v),
                            );
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      )
    );
  }

  void _showSettingsPanel(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: LatexTheme.sidebar,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ProjectBloc>(),
        child: const _SettingsSheet(),
      ),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        // Find all .tex files with \documentclass for the dropdown
        final mainCandidates = state.files
            .where(
              (f) =>
                  f.path.endsWith('.tex') &&
                  f.content.contains(r'\documentclass'),
            )
            .toList();

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 18,
                    color: LatexTheme.textPrimary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Project Settings',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: LatexTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Compiler
              const Text(
                'Compiler',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: LatexTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              _buildDropdown<String>(
                value: state.engine,
                items: const ['pdflatex', 'xelatex', 'lualatex', 'latexmk'],
                onChanged: (v) => context.read<ProjectBloc>().add(
                  ProjectEvent.setEngine(engine: v!),
                ),
              ),
              const SizedBox(height: 16),

              // Main Document
              const Text(
                'Main document',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: LatexTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              if (mainCandidates.isEmpty)
                const Text(
                  r'No files with \documentclass found',
                  style: TextStyle(
                    fontSize: 12,
                    color: LatexTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                _buildDropdown<String>(
                  value: mainCandidates.any((f) => f.path == state.mainFilePath)
                      ? state.mainFilePath!
                      : mainCandidates.first.path,
                  items: mainCandidates.map((f) => f.path).toList(),
                  onChanged: (v) => context.read<ProjectBloc>().add(
                    ProjectEvent.setMainFile(path: v!),
                  ),
                ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: LatexTheme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          isDense: true,
          style: const TextStyle(fontSize: 13, color: LatexTheme.textPrimary),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
