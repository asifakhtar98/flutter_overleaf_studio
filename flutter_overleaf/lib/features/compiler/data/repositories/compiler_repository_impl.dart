import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_overleaf/core/error/exceptions.dart';
import 'package:flutter_overleaf/core/error/failures.dart';
import 'package:flutter_overleaf/core/utils/typedefs.dart';
import 'package:flutter_overleaf/features/compiler/data/datasources/compiler_remote_datasource.dart';
import 'package:flutter_overleaf/features/compiler/domain/entities/compile_result.dart';
import 'package:flutter_overleaf/features/compiler/domain/repositories/compiler_repository.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';

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
    bool enableCache = true,
  }) async {
    try {
      final result = await _datasource.compileSingle(
        source: source,
        engine: engine,
        draft: draft,
        enableCache: enableCache,
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
    bool enableCache = true,
  }) async {
    try {
      final result = await _datasource.compileProject(
        files: files,
        mainFile: mainFile,
        engine: engine,
        draft: draft,
        enableCache: enableCache,
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
        requestId: error.requestId,
      );
    }
    if (error is AuthException) {
      _talker.warning('Auth error: ${error.errorCode} — ${error.message}');
      return Failure.auth(
        message: error.message,
        errorCode: error.errorCode,
        requestId: error.requestId,
      );
    }
    if (error is RateLimitException) {
      _talker.warning('Rate limited: ${error.message}');
      return Failure.rateLimited(
        message: error.message,
        requestId: error.requestId,
      );
    }
    if (error is UploadTooLargeException) {
      _talker.warning('Upload too large: ${error.message}');
      return Failure.uploadTooLarge(
        message: error.message,
        requestId: error.requestId,
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
