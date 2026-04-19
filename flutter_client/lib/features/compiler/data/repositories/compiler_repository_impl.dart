import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/core/error/exceptions.dart';
import 'package:flutter_latex_client/core/error/failures.dart';
import 'package:flutter_latex_client/core/utils/typedefs.dart';
import 'package:flutter_latex_client/features/compiler/data/datasources/compiler_remote_datasource.dart';
import 'package:flutter_latex_client/features/compiler/domain/entities/compile_result.dart';
import 'package:flutter_latex_client/features/compiler/domain/repositories/compiler_repository.dart';
import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';

@LazySingleton(as: CompilerRepository)
class CompilerRepositoryImpl implements CompilerRepository {
  const CompilerRepositoryImpl(this._datasource);

  final CompilerRemoteDatasource _datasource;

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
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapException(e));
    } on Exception catch (e) {
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
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapException(e));
    } on Exception catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  Failure _mapException(DioException e) {
    final error = e.error;
    if (error is CompilationException) {
      return Failure.compilation(
        log: error.log,
        errorCode: error.errorCode,
        compilationTime: error.compilationTime,
      );
    }
    if (error is NetworkException) {
      return Failure.network(message: error.message);
    }
    if (error is ServerException) {
      return Failure.server(
        message: error.message,
        errorCode: error.errorCode,
      );
    }
    return Failure.unknown(message: e.message);
  }
}
