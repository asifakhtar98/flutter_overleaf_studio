import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/core/error/failures.dart';
import 'package:flutter_latex_client/features/compiler/domain/usecases/compile_project.dart';
import 'package:flutter_latex_client/features/compiler/domain/usecases/compile_single.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_latex_client/features/compiler/presentation/bloc/compiler_state.dart';
import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';

@injectable
class CompilerBloc extends Bloc<CompilerEvent, CompilerState> {
  CompilerBloc({
    required CompileSingle compileSingle,
    required CompileProject compileProject,
  })  : _compileSingle = compileSingle,
        _compileProject = compileProject,
        super(const CompilerState.initial()) {
    on<CompileRequested>(_onCompileRequested);
    on<CompileReset>(_onReset);
  }

  final CompileSingle _compileSingle;
  final CompileProject _compileProject;

  /// Set externally by the editor page to access current project files.
  List<ProjectFile> Function()? getProjectFiles;
  String Function()? getActiveContent;
  String Function()? getMainFileName;

  Future<void> _onCompileRequested(
    CompileRequested event,
    Emitter<CompilerState> emit,
  ) async {
    emit(CompilerState.loading(engine: event.engine));

    final files = getProjectFiles?.call() ?? [];
    final mainFile = getMainFileName?.call() ?? 'main.tex';

    if (files.length <= 1) {
      final source = getActiveContent?.call() ?? '';
      final result = await _compileSingle(
        CompileSingleParams(
          source: source,
          engine: event.engine,
          draft: event.draft,
        ),
      );

      result.fold(
        (failure) => emit(_mapFailure(failure)),
        (result) => emit(CompilerState.success(result: result)),
      );
    } else {
      final result = await _compileProject(
        CompileProjectParams(
          files: files,
          mainFile: mainFile,
          engine: event.engine,
          draft: event.draft,
        ),
      );

      result.fold(
        (failure) => emit(_mapFailure(failure)),
        (result) => emit(CompilerState.success(result: result)),
      );
    }
  }

  CompilerState _mapFailure(Failure failure) {
    return switch (failure) {
      ServerFailure(:final message, :final errorCode) =>
        CompilerState.failure(
          errorCode: errorCode ?? 'SERVER_ERROR',
          log: message,
        ),
      NetworkFailure(:final message) => CompilerState.failure(
          errorCode: 'NETWORK_ERROR',
          log: message,
        ),
      CompilationFailure(
        :final log,
        :final errorCode,
        :final compilationTime,
      ) =>
        CompilerState.failure(
          errorCode: errorCode,
          log: log,
          compilationTime: compilationTime,
        ),
      ValidationFailure(:final message) => CompilerState.failure(
          errorCode: 'VALIDATION_ERROR',
          log: message,
        ),
      UnknownFailure(:final message) => CompilerState.failure(
          errorCode: 'UNKNOWN',
          log: message ?? 'Unknown error',
        ),
    };
  }

  void _onReset(CompileReset event, Emitter<CompilerState> emit) {
    emit(const CompilerState.initial());
  }
}
