import 'package:flutter_overleaf/features/compiler/domain/entities/log_entry.dart';
import 'package:flutter_overleaf/features/compiler/domain/utils/latex_log_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseLatexLog', () {
    test('parses file:line:message errors', () {
      const log = './main.tex:42: Undefined control sequence.';
      final entries = parseLatexLog(log);
      expect(entries.length, 1);
      expect(entries[0].severity, LogSeverity.error);
      expect(entries[0].filePath, 'main.tex');
      expect(entries[0].line, 42);
      expect(entries[0].message, 'Undefined control sequence.');
    });

    test('parses bang errors with l.N lookahead', () {
      const log = '''! Missing \$ inserted.
<inserted text> 
                \$
l.15 some math x^2''';
      final entries = parseLatexLog(log);
      expect(entries.isNotEmpty, true);
      expect(entries[0].severity, LogSeverity.error);
      expect(entries[0].line, 15);
    });

    test('parses LaTeX warnings', () {
      const log = "LaTeX Warning: Reference `foo' on page 1 undefined";
      final entries = parseLatexLog(log);
      expect(entries.length, 1);
      expect(entries[0].severity, LogSeverity.warning);
    });

    test('parses Package warnings', () {
      const log = 'Package hyperref Warning: Token not allowed in a PDF string';
      final entries = parseLatexLog(log);
      expect(entries.length, 1);
      expect(entries[0].severity, LogSeverity.warning);
    });

    test('parses overfull/underfull box warnings', () {
      const log = r'Overfull \hbox (12.3pt too wide) in paragraph at lines 10--15';
      final entries = parseLatexLog(log);
      expect(entries.length, 1);
      expect(entries[0].severity, LogSeverity.warning);
    });

    test('deduplicates identical entries', () {
      const log = '''./main.tex:10: Undefined control sequence.
./main.tex:10: Undefined control sequence.''';
      final entries = parseLatexLog(log);
      expect(entries.length, 1);
    });

    test('returns empty list for empty log', () {
      expect(parseLatexLog(''), isEmpty);
    });

    test('sorts errors before warnings', () {
      const log = '''LaTeX Warning: Something went wrong
./main.tex:5: Undefined control sequence.''';
      final entries = parseLatexLog(log);
      expect(entries.length, 2);
      expect(entries[0].severity, LogSeverity.error);
      expect(entries[1].severity, LogSeverity.warning);
    });

    test('parses real server error log', () {
      const log = '''This is pdfTeX, Version 3.141592653
(/dev/shm/texlive__u33fty_/main.tex
LaTeX2e <2025-11-01>
(/usr/local/texlive/texmf-dist/tex/latex/base/article.cls
Document Class: article 2025/01/22 v1.4n Standard LaTeX document class
(/usr/local/texlive/texmf-dist/tex/latex/base/size10.clo))
(/usr/local/texlive/texmf-dist/tex/latex/l3backend/l3backend-pdftex.def)
No file main.aux.
! Undefined control sequence.
l.3 Hello \\badcommand
                     
!  ==> Fatal error occurred, no output PDF file produced!
Transcript written on /dev/shm/texlive__u33fty_/main.log.''';
      final entries = parseLatexLog(log);
      expect(entries.where((e) => e.severity == LogSeverity.error).length,
          greaterThanOrEqualTo(1));
      // The bang error should have line 3
      final bangError = entries.firstWhere(
          (e) => e.message.contains('Undefined control sequence'));
      expect(bangError.line, 3);
    });
  });
}
