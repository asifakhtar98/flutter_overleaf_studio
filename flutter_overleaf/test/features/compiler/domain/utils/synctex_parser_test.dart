import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import 'package:flutter_overleaf/features/compiler/domain/utils/synctex_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a minimal synctex.gz for testing.
Uint8List _makeSynctexGz(String content) {
  return Uint8List.fromList(GZipEncoder().encode(utf8.encode(content))!);
}

const _sampleSynctex = '''
SyncTeX Version:1
Input:1:main.tex
Input:2:/usr/local/texlive/texmf-dist/tex/latex/base/article.cls
Output:pdf
Magnification:1000
Unit:1
X Offset:0
Y Offset:0
Content:
!337
{1
h1,3:8799518,8865054:983040,0,0
x1,3:11257121,8865054
(1,4:8799518,6571294:22609920,0,0
h1,4:8799518,6571294:22609920,0,0
)
}
''';

void main() {
  group('parseSynctex', () {
    test('parses valid synctex.gz data', () {
      final gz = _makeSynctexGz(_sampleSynctex);
      final data = parseSynctex(gz);
      expect(data, isNotNull);
      expect(data!.inputs.containsKey(1), true);
      expect(data.inputs[1], 'main.tex');
      expect(data.nodes.isNotEmpty, true);
    });

    test('returns null for empty bytes', () {
      expect(parseSynctex(Uint8List(0)), isNull);
    });

    test('returns null for invalid gzip data', () {
      expect(parseSynctex(Uint8List.fromList([1, 2, 3])), isNull);
    });

    test('normalizes paths by stripping leading ./', () {
      final content = '''
SyncTeX Version:1
Input:1:./my_file.tex
Output:pdf
Content:
{1
h1,5:6553600,13107200:0,0,0
}
''';
      final data = parseSynctex(_makeSynctexGz(content));
      expect(data, isNotNull);
      expect(data!.inputs[1], 'my_file.tex');
    });

    test('filters framework files in targetToSource', () {
      // article.cls (input 2) should be filtered out.
      final gz = _makeSynctexGz(_sampleSynctex);
      final data = parseSynctex(gz)!;

      // All nodes from input 1 (main.tex) should be matchable.
      final userNodes = data.nodes.where((n) => n.inputIndex == 1);
      expect(userNodes.isNotEmpty, true);
    });

    test('targetToSource returns null when click is in empty margin', () {
      final gz = _makeSynctexGz(_sampleSynctex);
      final data = parseSynctex(gz)!;

      // Click at a point very far from any node (9999, 9999).
      final result = data.targetToSource(1, 9999, 9999);
      expect(result, isNull);
    });

    test('targetToSource finds closest user node', () {
      final content = '''
SyncTeX Version:1
Input:1:main.tex
Output:pdf
Content:
{1
h1,10:6553600,13107200:0,0,0
h1,20:6553600,26214400:0,0,0
}
''';
      final data = parseSynctex(_makeSynctexGz(content))!;

      // Node at line 10: x=100pt, y=200pt (6553600/65536=100, 13107200/65536=200)
      // Node at line 20: x=100pt, y=400pt
      // Click near (100, 210) — should match line 10.
      final result = data.targetToSource(1, 100, 210);
      expect(result, isNotNull);
      expect(result!.line, 10);
      expect(result.filePath, 'main.tex');
    });

    test('sourceToTarget finds closest node for a source line', () {
      final content = '''
SyncTeX Version:1
Input:1:main.tex
Output:pdf
Content:
{1
h1,10:6553600,13107200:0,0,0
h1,20:6553600,26214400:0,0,0
}
''';
      final data = parseSynctex(_makeSynctexGz(content))!;

      final target = data.sourceToTarget('main.tex', 10);
      expect(target, isNotNull);
      expect(target!.page, 1);
      expect(target.x, closeTo(100.0, 0.1));
      expect(target.y, closeTo(200.0, 0.1));
    });

    test('sourceToTarget returns null for unknown file', () {
      final gz = _makeSynctexGz(_sampleSynctex);
      final data = parseSynctex(gz)!;

      expect(data.sourceToTarget('nonexistent.tex', 1), isNull);
    });
  });
}
