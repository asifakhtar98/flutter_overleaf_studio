import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_overleaf/core/models/engine.dart';
import 'package:flutter_overleaf/core/utils/typedefs.dart';
import 'package:flutter_overleaf/features/compiler/domain/entities/compile_result.dart';
import 'package:flutter_overleaf/features/compiler/domain/repositories/compiler_repository.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';

part 'compile_project.freezed.dart';

@freezed
sealed class CompileProjectParams with _$CompileProjectParams {
  const factory CompileProjectParams({
    required List<ProjectFile> files,
    required String mainFile,
    @Default(Engine.pdflatex) Engine engine,
    @Default(false) bool draft,
    @Default(true) bool enableCache,
  }) = _CompileProjectParams;
}

@injectable
class CompileProject {
  const CompileProject(this._repository);

  final CompilerRepository _repository;

  FutureEither<CompileResult> call(CompileProjectParams params) =>
      _repository.compileProject(
        files: params.files,
        mainFile: params.mainFile,
        engine: params.engine.name,
        draft: params.draft,
        enableCache: params.enableCache,
      );
}
