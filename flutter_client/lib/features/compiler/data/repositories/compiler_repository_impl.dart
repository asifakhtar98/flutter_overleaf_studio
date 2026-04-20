import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_latex_client/core/error/exceptions.dart';
import 'package:flutter_latex_client/core/error/failures.dart';
import 'package:flutter_latex_client/core/utils/typedefs.dart';
import 'package:flutter_latex_client/features/compiler/data/datasources/compiler_remote_datasource.dart';
import 'package:flutter_latex_client/features/compiler/domain/entities/compile_result.dart';
import 'package:flutter_latex_client/features/compiler/domain/repositories/compiler_repository.dart';
import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';

@LazySingleton(as: CompilerRepository)
class CompilerRepositoryImpl implements CompilerRepository {
  const CompilerRepositoryImpl(this._datasource, this._talker);

  final CompilerRemoteDatasource _datasource;
  final Talker _talker;

  @override
  FutureEither<CompileResult> compileSingle({
    required String source,
    String engine = 'pdflatex',
    bool draft = false,
  }) async {
    try {
      final result = await _datasource.compileSingle(
        source: source,
        engine: engine,
        draft: draft,
      );
      _logSuccess(result);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapException(e));
    } on Exception catch (e, st) {
      _talker.handle(e, st, 'Unexpected compilation error');
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  FutureEither<CompileResult> compileProject({
    required List<ProjectFile> files,
    required String mainFile,
    String engine = 'pdflatex',
    bool draft = false,
  }) async {
    try {
      final result = await _datasource.compileProject(
        files: files,
        mainFile: mainFile,
        engine: engine,
        draft: draft,
      );
      _logSuccess(result);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapException(e));
    } on Exception catch (e, st) {
      _talker.handle(e, st, 'Unexpected compilation error');
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  void _logSuccess(CompileResult result) {
    _talker.info(
      'Compilation OK: ${result.compilationTime.toStringAsFixed(2)}s '
      '| engine=${result.engine} '
      '| cached=${result.cached} '
      '| passes=${result.passesRun} '
      '| warnings=${result.warningsCount}',
    );
  }

  Failure _mapException(DioException e) {
    final error = e.error;
    if (error is CompilationException) {
      _talker.error(
        'Compilation failed: ${error.errorCode} '
        '| time=${error.compilationTime?.toStringAsFixed(2) ?? "?"}s',
      );
      return Failure.compilation(
        log: error.log,
        errorCode: error.errorCode,
        compilationTime: error.compilationTime,
      );
    }
    if (error is NetworkException) {
      _talker.warning('Network error: ${error.message}');
      return Failure.network(message: error.message);
    }
    if (error is ServerException) {
      _talker.error(
        'Server error ${error.statusCode}: '
        '${error.errorCode} — ${error.message}',
      );
      return Failure.server(message: error.message, errorCode: error.errorCode);
    }
    _talker.warning('Unknown DioException: ${e.message}');
    return Failure.unknown(message: e.message);
  }
}
