import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/core/utils/typedefs.dart';
import 'package:flutter_latex_client/features/compiler/domain/entities/compile_result.dart';
import 'package:flutter_latex_client/features/compiler/domain/repositories/compiler_repository.dart';

part 'compile_single.freezed.dart';

@freezed
sealed class CompileSingleParams with _$CompileSingleParams {
  const factory CompileSingleParams({
    required String source,
    @Default('pdflatex') String engine,
    @Default(false) bool draft,
  }) = _CompileSingleParams;
}

@injectable
class CompileSingle {
  const CompileSingle(this._repository);

  final CompilerRepository _repository;

  FutureEither<CompileResult> call(CompileSingleParams params) =>
      _repository.compileSingle(
        source: params.source,
        engine: params.engine,
        draft: params.draft,
      );
}
