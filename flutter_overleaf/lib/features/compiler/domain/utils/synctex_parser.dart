import 'package:archive/archive.dart';
import 'dart:convert';
import 'dart:typed_data';

/// Parsed SyncTeX mapping data for source↔PDF navigation.
class SynctexData {
  SynctexData({required this.inputs, required this.nodes});

  /// Map from input index (1-based) → file path.
  final Map<int, String> inputs;

  /// All positional nodes extracted from the synctex data.
  final List<SynctexNode> nodes;

  /// Look up the PDF target for a given source file and line.
  ///
  /// Returns the first matching node's page and position, or null.
  SynctexTarget? sourceToTarget(String file, int line) {
    // Find input index for this file.
    final inputIdx = _findInputIndex(file);
    if (inputIdx == null) return null;

    // Find the closest node for this input and line.
    SynctexNode? best;
    var bestDist = 999999;

    for (final node in nodes) {
      if (node.inputIndex != inputIdx) continue;
      final dist = (node.line - line).abs();
      if (dist < bestDist) {
        bestDist = dist;
        best = node;
      }
      if (dist == 0) break; // exact match
    }

    if (best == null) return null;
    return SynctexTarget(page: best.page, x: best.x, y: best.y);
  }

  /// Look up the source location for a PDF click position.
  ///
  /// [page] is 1-indexed. [x] and [y] are in PDF points.
  /// [y] should already be flipped to bottom-left origin by the caller.
  /// Returns the closest node's source file and line, or null if no
  /// match is within [maxDistance] points.
  SynctexSource? targetToSource(
    int page,
    double x,
    double y, {
    double maxDistance = 100.0,
  }) {
    SynctexNode? best;
    var bestDistSq = double.infinity;
    final maxDistSq = maxDistance * maxDistance;

    for (final node in nodes) {
      if (node.page != page) continue;
      // Skip framework/system files — only navigate to user files.
      final filePath = inputs[node.inputIndex];
      if (filePath == null || _isFrameworkFile(filePath)) continue;

      final dx = node.x - x;
      final dy = node.y - y;
      final distSq = dx * dx + dy * dy;
      if (distSq < bestDistSq) {
        bestDistSq = distSq;
        best = node;
      }
    }

    if (best == null || bestDistSq > maxDistSq) return null;
    final file = inputs[best.inputIndex];
    if (file == null) return null;
    return SynctexSource(filePath: file, line: best.line);
  }

  /// Returns true if [path] is a TeX Live system/framework file.
  static bool _isFrameworkFile(String path) {
    return path.contains('texmf-dist/') ||
        path.endsWith('.cls') ||
        path.endsWith('.sty') ||
        path.endsWith('.def') ||
        path.endsWith('.clo') ||
        path.endsWith('.fd') ||
        path.endsWith('.cfg');
  }

  int? _findInputIndex(String file) {
    // Try exact match first, then basename match.
    for (final entry in inputs.entries) {
      if (entry.value == file) return entry.key;
    }
    for (final entry in inputs.entries) {
      if (entry.value.endsWith('/$file') || entry.value.endsWith(file)) {
        return entry.key;
      }
    }
    return null;
  }
}

/// A resolved PDF target from a source location.
class SynctexTarget {
  const SynctexTarget({required this.page, required this.x, required this.y});
  final int page;
  final double x;
  final double y;
}

/// A resolved source location from a PDF position.
class SynctexSource {
  const SynctexSource({required this.filePath, required this.line});
  final String filePath;
  final int line;
}

/// A single positional node from the synctex data.
class SynctexNode {
  const SynctexNode({
    required this.inputIndex,
    required this.line,
    required this.page,
    required this.x,
    required this.y,
  });
  final int inputIndex;
  final int line;
  final int page;
  final double x;
  final double y;
}

// ---------------------------------------------------------------------------
// Regex patterns for synctex format (pre-compiled).
// ---------------------------------------------------------------------------
final _inputLine = RegExp(r'^Input:(\d+):(.+)$');
final _pageOpen = RegExp(r'^\{(\d+)$');
final _contentNode = RegExp(r'^[(\[hxvkg](\d+),(\d+):(-?\d+),(-?\d+)');

/// Parses raw `.synctex.gz` bytes into a [SynctexData] structure.
///
/// Returns null if the data cannot be decompressed or parsed.
SynctexData? parseSynctex(Uint8List gzBytes) {
  if (gzBytes.isEmpty) return null;

  String content;
  try {
    final decompressed = const GZipDecoder().decodeBytes(gzBytes);
    content = utf8.decode(decompressed, allowMalformed: true);
  } on Object {
    return null;
  }

  final inputs = <int, String>{};
  final nodes = <SynctexNode>[];
  var currentPage = 0;

  for (final line in content.split('\n')) {
    // Input declarations
    final inputMatch = _inputLine.firstMatch(line);
    if (inputMatch != null) {
      final idx = int.tryParse(inputMatch.group(1) ?? '');
      final path = inputMatch.group(2);
      if (idx != null && path != null) {
        // Normalize path: strip leading ./ and absolute prefix
        var normalized = path;
        if (normalized.startsWith('./')) {
          normalized = normalized.substring(2);
        }
        inputs[idx] = normalized;
      }
      continue;
    }

    // Page boundaries
    final pageMatch = _pageOpen.firstMatch(line);
    if (pageMatch != null) {
      currentPage = int.tryParse(pageMatch.group(1) ?? '0') ?? 0;
      continue;
    }

    // Content nodes: type + inputIdx,line:x,y:w,h,d
    final nodeMatch = _contentNode.firstMatch(line);
    if (nodeMatch != null) {
      final inputIdx = int.tryParse(nodeMatch.group(1) ?? '') ?? 0;
      final nodeLine = int.tryParse(nodeMatch.group(2) ?? '') ?? 0;
      final x = int.tryParse(nodeMatch.group(3) ?? '0') ?? 0;
      final y = int.tryParse(nodeMatch.group(4) ?? '0') ?? 0;

      if (nodeLine > 0) {
        nodes.add(SynctexNode(
          inputIndex: inputIdx,
          line: nodeLine,
          page: currentPage,
          // SyncTeX coordinates are in scaled points (sp).
          // 1 pt = 65536 sp. Convert to points for PDF usage.
          x: x / 65536.0,
          y: y / 65536.0,
        ));
      }
    }
  }

  if (inputs.isEmpty && nodes.isEmpty) return null;
  return SynctexData(inputs: inputs, nodes: nodes);
}
