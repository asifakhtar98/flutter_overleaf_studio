import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_overleaf/core/error/failures.dart';
import 'package:flutter_overleaf/features/compiler/domain/usecases/compile_project.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_event.dart';
import 'package:flutter_overleaf/features/compiler/presentation/bloc/compiler_state.dart';

@injectable
class CompilerBloc extends Bloc<CompilerEvent, CompilerState> {
  CompilerBloc({required CompileProject compileProject})
    : _compileProject = compileProject,
      super(const CompilerState.initial()) {
    on<CompileRequested>(_onCompileRequested);
    on<CompileReset>(_onReset);
  }

  final CompileProject _compileProject;

  Future<void> _onCompileRequested(
    CompileRequested event,
    Emitter<CompilerState> emit,
  ) async {
    emit(CompilerState.loading(engine: event.engine));

    final result = await _compileProject(
      CompileProjectParams(
        files: event.files,
        mainFile: event.mainFile,
        engine: event.engine,
        draft: event.draft,
      ),
    );

    result.fold(
      (failure) => emit(_mapFailure(failure)),
      (result) => emit(CompilerState.success(result: result)),
    );
  }

  CompilerState _mapFailure(Failure failure) {
    return switch (failure) {
      ServerFailure(:final message, :final errorCode) => CompilerState.failure(
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
