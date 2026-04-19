import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pdfrx/pdfrx.dart';

import 'package:flutter_latex_client/core/theme/latex_theme.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_state.dart';

class PdfViewerPanel extends HookWidget {
  const PdfViewerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfController = useMemoized(PdfViewerController.new);
    
    final lastPdfBytes = useState<Uint8List?>(null);

    return BlocConsumer<CompilerBloc, CompilerState>(
      listener: (context, state) {
        if (state is CompilerSuccess) {
          lastPdfBytes.value = state.result.pdfBytes;
        }
      },
      builder: (context, state) {
        final hasPdf = lastPdfBytes.value != null;
        
        final stateLayer = switch (state) {
          CompilerInitial() => hasPdf ? const SizedBox.shrink() : const _EmptyState(),
          CompilerLoading(:final engine) =>
            _LoadingOverlay(engine: engine, hasBackground: hasPdf),
          CompilerSuccess() => const SizedBox.shrink(),
          CompilerFailure() => _ErrorState(state: state),
        };

        return Stack(
          children: [
            if (hasPdf)
              PdfViewer.data(
                lastPdfBytes.value!,
                sourceName: 'output.pdf',
                controller: pdfController,
                params: const PdfViewerParams(
                  backgroundColor: LatexTheme.surface,
                ),
              ),
            Positioned.fill(child: stateLayer),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: LatexTheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.picture_as_pdf_outlined,
              size: 64,
              color: LatexTheme.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            const Text(
              'Compile to see PDF preview',
              style: TextStyle(
                color: LatexTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay({required this.engine, required this.hasBackground});

  final String engine;
  final bool hasBackground;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: hasBackground 
          ? LatexTheme.surface.withValues(alpha: 0.7)
          : LatexTheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 16),
            Text(
              'Compiling with $engine…',
              style: const TextStyle(
                color: LatexTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.state});

  final CompilerFailure state;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: LatexTheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: LatexTheme.error,
              ),
              const SizedBox(height: 16),
              const Text(
                'Compilation Failed',
                style: TextStyle(
                  color: LatexTheme.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorCode,
                style: const TextStyle(
                  color: LatexTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
