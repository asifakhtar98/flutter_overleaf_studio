import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_event.dart';
import 'package:flutter_latex_client/features/project/presentation/bloc/project_state.dart';

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
      child: InkWell(
        onTap: () => _showSettingsPanel(context),
        borderRadius: BorderRadius.circular(4),
        child: const Row(
          children: [
            Icon(
              Icons.settings_outlined,
              size: 16,
              color: LatexTheme.textSecondary,
            ),
            SizedBox(width: 8),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 12,
                color: LatexTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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
