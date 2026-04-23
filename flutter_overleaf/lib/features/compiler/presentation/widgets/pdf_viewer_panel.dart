import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_overleaf/core/models/engine.dart';
import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_state.dart';

class PdfViewerPanel extends HookWidget {
  const PdfViewerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfController = useMemoized(PdfViewerController.new);

    final lastPdfBytes = useState<Uint8List?>(null);
    final showSuccess = useState(false);

    return BlocConsumer<CompilerBloc, CompilerState>(
      listener: (context, state) {
        if (state is CompilerSuccess) {
          lastPdfBytes.value = state.result.pdfBytes;
          // Brief success flash
          showSuccess.value = true;
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (context.mounted) showSuccess.value = false;
          });
        }
      },
      builder: (context, state) {
        final hasPdf = lastPdfBytes.value != null;

        final stateLayer = switch (state) {
          CompilerInitial() =>
            hasPdf ? const SizedBox.shrink() : const _EmptyState(),
          CompilerLoading(:final engine) => _LoadingOverlay(
            engine: engine,
            hasBackground: hasPdf,
          ),
          CompilerSuccess() => const SizedBox.shrink(),
          CompilerFailure() => _ErrorState(state: state),
        };

        return Stack(
          children: [
            if (hasPdf)
              PdfViewer.data(
                lastPdfBytes.value!,
                sourceName: 'output_${lastPdfBytes.value.hashCode}.pdf',
                controller: pdfController,
                params: const PdfViewerParams(
                  backgroundColor: LatexTheme.surface,
                ),
              ),
            if (state is! CompilerSuccess) stateLayer,
            // Success flash
            if (showSuccess.value)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, opacity, child) {
                    return Opacity(opacity: opacity, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: LatexTheme.success.withValues(alpha: 0.9),
                      boxShadow: [
                        BoxShadow(
                          color: LatexTheme.success.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          state is CompilerSuccess &&
                                  state.result.cached
                              ? 'Compiled (cached)'
                              : 'Compiled successfully',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Download/Share FAB
            if (hasPdf && state is! CompilerLoading)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.small(
                  onPressed: () => _sharePdf(lastPdfBytes.value!),
                  backgroundColor: LatexTheme.primary,
                  tooltip: 'Download PDF',
                  child: const Icon(Icons.download, size: 20),
                ),
              ),
          ],
        );
      },
    );
  }

  void _sharePdf(Uint8List bytes) {
    SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'application/pdf', name: 'output.pdf')],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
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
                style: TextStyle(color: LatexTheme.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay({required this.engine, required this.hasBackground});

  final Engine engine;
  final bool hasBackground;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: LatexTheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LinearProgressIndicator(
              backgroundColor: LatexTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(LatexTheme.primary),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Compiling with ${engine.label}…',
                    style: const TextStyle(
                      color: LatexTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
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
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        elevation: 8,
        color: LatexTheme.error.withValues(alpha: 0.95),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.error_outline, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Compilation Failed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      state.errorCode,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                onPressed: () => context
                    .read<CompilerBloc>()
                    .add(const CompilerEvent.reset()),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Dismiss',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
