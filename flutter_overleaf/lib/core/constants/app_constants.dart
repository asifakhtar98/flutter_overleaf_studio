const defaultMainTex = r'''
\documentclass{article}
\begin{document}

Hello, \LaTeX!

\end{document}
''';

/// Canonical set of extensions treated as binary (non-UTF-8) files.
/// Used by import, upload, and file-tree display logic.
const kBinaryExtensions = {
  '.png',
  '.jpg',
  '.jpeg',
  '.pdf',
  '.ttf',
  '.otf',
  '.gif',
  '.bmp',
  '.svg',
  '.ico',
  '.webp',
  '.zip',
  '.tar',
  '.gz',
  '.mp4',
  '.mp3',
  '.wav',
  '.eps',
};

/// Per-file upload size warning threshold (10 MB).
const kMaxUploadFileSizeBytes = 10 * 1024 * 1024;

/// Returns `true` if [fileName] has a known binary extension.
bool isBinaryFileName(String fileName) {
  final dotIndex = fileName.lastIndexOf('.');
  if (dotIndex == -1) return false;
  final ext = fileName.toLowerCase().substring(dotIndex);
  return kBinaryExtensions.contains(ext);
}
