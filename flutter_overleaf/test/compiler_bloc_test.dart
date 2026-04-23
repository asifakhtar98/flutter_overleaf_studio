import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_overleaf/core/error/failures.dart';
import 'package:flutter_overleaf/core/models/engine.dart';
import 'package:flutter_overleaf/features/compiler/domain/entities/compile_result.dart';
import 'package:flutter_overleaf/features/compiler/domain/usecases/compile_project.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_bloc.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_state.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';

class MockCompileProject extends Mock implements CompileProject {}

void main() {
  late MockCompileProject mockCompile;

  setUpAll(() => registerFallbackValue(
    const CompileProjectParams(files: [], mainFile: ''),
  ));

  setUp(() => mockCompile = MockCompileProject());

  final testResult = CompileResult(
    pdfBytes: Uint8List.fromList([0x25, 0x50, 0x44, 0x46]),
    log: 'Output written',
    compilationTime: 1.5,
    engine: 'pdflatex',
    warningsCount: 0,
    passesRun: 1,
    cached: false,
  );

  const testFiles = [
    ProjectFile(
      name: 'main.tex',
      path: 'main.tex',
      content: r'\documentclass{article}',
    ),
  ];

  group('CompilerBloc', () {
    blocTest<CompilerBloc, CompilerState>(
      'emits loading then success on compile',
      build: () {
        when(() => mockCompile(any()))
            .thenAnswer((_) async => Right(testResult));
        return CompilerBloc(compileProject: mockCompile);
      },
      act: (b) => b.add(
        const CompilerEvent.compileRequested(
          engine: Engine.pdflatex,
          draft: false,
          files: testFiles,
          mainFile: 'main.tex',
        ),
      ),
      expect: () => [
        const CompilerState.loading(engine: Engine.pdflatex),
        CompilerState.success(result: testResult),
      ],
    );

    blocTest<CompilerBloc, CompilerState>(
      'emits loading then failure on compile error',
      build: () {
        when(() => mockCompile(any())).thenAnswer(
          (_) async => const Left(
            Failure.compilation(
              log: 'Undefined control sequence',
              errorCode: 'COMPILATION_FAILED',
              compilationTime: 2,
            ),
          ),
        );
        return CompilerBloc(compileProject: mockCompile);
      },
      act: (b) => b.add(
        const CompilerEvent.compileRequested(
          engine: Engine.pdflatex,
          draft: false,
          files: testFiles,
          mainFile: 'main.tex',
        ),
      ),
      expect: () => [
        const CompilerState.loading(engine: Engine.pdflatex),
        isA<CompilerFailure>()
            .having((s) => s.errorCode, 'errorCode', 'COMPILATION_FAILED')
            .having((s) => s.compilationTime, 'compilationTime', 2.0),
      ],
    );

    blocTest<CompilerBloc, CompilerState>(
      'reset returns to initial',
      build: () => CompilerBloc(compileProject: mockCompile),
      seed: () => CompilerState.success(result: testResult),
      act: (b) => b.add(const CompilerEvent.reset()),
      expect: () => [const CompilerState.initial()],
    );
  });
}
