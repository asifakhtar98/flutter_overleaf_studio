import 'package:flutter_latex_client/core/utils/typedefs.dart';
import 'package:flutter_latex_client/features/compiler/domain/entities/compile_result.dart';
import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';

abstract class CompilerRepository {
  FutureEither<CompileResult> compileSingle({
    required String source,
    String engine,
    bool draft,
  });

  FutureEither<CompileResult> compileProject({
    required List<ProjectFile> files,
    required String mainFile,
    String engine,
    bool draft,
  });
}
