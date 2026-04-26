import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_overleaf/core/theme/latex_theme.dart';
import 'package:flutter_overleaf/features/compiler/domain/utils/synctex_parser.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_state.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:flutter_overleaf/features/editor/presentation/bloc/editor_event.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_bloc.dart';
import 'package:flutter_overleaf/features/project/presentation/bloc/project_state.dart';
import 'package:flutter_overleaf/core/models/engine.dart';

class PdfViewerPanel extends StatefulWidget {
  const PdfViewerPanel({super.key});

  @override
  State<PdfViewerPanel> createState() => _PdfViewerPanelState();
}

class _PdfViewerPanelState extends State<PdfViewerPanel> {
  final _pdfController = PdfViewerController();

  Uint8List? _lastPdfBytes;
  bool _showSuccess = false;

  /// Parsed SyncTeX data from the latest successful compilation.
  SynctexData? _synctexData;

  /// The loaded PDF document (set via onViewerReady).
  PdfDocument? _pdfDocument;

  /// Tap feedback state.
  int? _tapPageNumber;
  Offset? _tapOffsetInPage;


  // ---------------------------------------------------------------------------
  // SyncTeX reverse lookup: PDF tap → source line
  // ---------------------------------------------------------------------------

  void _onPdfTap(TapUpDetails details) {
    if (_synctexData == null || _pdfDocument == null) return;

    // 1. Global → document coordinates (pdfrx points, top-left origin).
    final docPos = _pdfController.globalToDocument(details.globalPosition);
    if (docPos == null) return;

    // 2. Find which page was tapped.
    final pageLayouts = _pdfController.layout.pageLayouts;
    final pageIndex =
        pageLayouts.indexWhere((rect) => rect.contains(docPos));
    if (pageIndex < 0) return;

    // 3. In-page offset (top-left origin, unzoomed points).
    final offsetInPage = docPos - pageLayouts[pageIndex].topLeft;

    // 4. Get page height for Y-axis flip.
    final page = _pdfDocument!.pages[pageIndex];
    final pageHeight = page.height;

    // 5. SyncTeX lookup with Y-flip (pdfrx=top-left → synctex=bottom-left).
    final source = _synctexData!.targetToSource(
      pageIndex + 1, // SyncTeX pages are 1-indexed
      offsetInPage.dx,
      pageHeight - offsetInPage.dy,
    );

    // 6. Show brief visual feedback at click point.
    setState(() {
      _tapPageNumber = pageIndex + 1;
      _tapOffsetInPage = offsetInPage;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _tapPageNumber = null);
    });

    if (source == null) return;

    // 7. Resolve the synctex file path to a project file.
    // The server always renames to main.tex, so fall back to mainFilePath.
    final projectState = context.read<ProjectBloc>().state;
    final matchedPath = _resolveFilePath(source.filePath, projectState);
    if (matchedPath == null) return;

    // 8. Navigate to source line.
    context.read<EditorBloc>().add(
      EditorEvent.navigateToLine(path: matchedPath, line: source.line),
    );
  }

  /// Maps a synctex file path to a project file path.
  ///
  /// The server renames uploaded files to `main.tex`, so synctex always
  /// reports that name. Try exact/suffix match first, then fall back to
  /// the project's designated main file.
  static String? _resolveFilePath(String synctexPath, ProjectState project) {
    for (final f in project.files) {
      if (f.path == synctexPath ||
          f.path.endsWith('/$synctexPath')) {
        return f.path;
      }
    }
    // Fall back to main file — the server always compiles as main.tex.
    return project.mainFilePath ?? project.activeFilePath;
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompilerBloc, CompilerState>(
      listener: (context, state) {
        if (state is CompilerSuccess) {
          _lastPdfBytes = state.result.pdfBytes;

          // Parse SyncTeX data for reverse lookup.
          final synctexBytes = state.result.synctexBytes;
          _synctexData = (synctexBytes != null && synctexBytes.isNotEmpty)
              ? parseSynctex(synctexBytes)
              : null;

          // Brief success flash.
          _showSuccess = true;
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) setState(() => _showSuccess = false);
          });
        }
      },
      builder: (context, state) {
        final hasPdf = _lastPdfBytes != null;

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
                _lastPdfBytes!,
                sourceName: 'output_${_lastPdfBytes.hashCode}.pdf',
                controller: _pdfController,
                params: PdfViewerParams(
                  backgroundColor: LatexTheme.surface,
                  // Capture tap events for SyncTeX reverse lookup.
                  viewerOverlayBuilder:
                      (context, size, handleLinkTap) => [
                        Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTapUp: _onPdfTap,
                          ),
                        ),
                      ],
                  // Visual feedback: brief marker at clicked position.
                  pageOverlaysBuilder: (context, pageRect, page) {
                    if (_tapPageNumber != page.pageNumber ||
                        _tapOffsetInPage == null) {
                      return [];
                    }
                    final zoom = _pdfController.currentZoom;
                    return [
                      Positioned(
                        left: _tapOffsetInPage!.dx * zoom - 8,
                        top: _tapOffsetInPage!.dy * zoom - 8,
                        child: IgnorePointer(
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: LatexTheme.primary.withValues(alpha: 0.4),
                              border: Border.all(
                                color: LatexTheme.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  // Store the document reference for page height lookups.
                  onViewerReady: (document, controller) {
                    _pdfDocument = document;
                  },
                ),
              ),
            if (state is! CompilerSuccess) stateLayer,
            // Success flash
            if (_showSuccess)
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
                  onPressed: () => _sharePdf(_lastPdfBytes!),
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
