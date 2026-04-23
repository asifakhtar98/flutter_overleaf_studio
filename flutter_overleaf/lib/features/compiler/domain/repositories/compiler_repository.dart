import 'package:flutter_overleaf/core/utils/typedefs.dart';
import 'package:flutter_overleaf/features/compiler/domain/entities/compile_result.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';

abstract class CompilerRepository {
  FutureEither<CompileResult> compileSingle({
    required String source,
    String engine,
    bool draft,
    bool enableCache,
  });

  FutureEither<CompileResult> compileProject({
    required List<ProjectFile> files,
    required String mainFile,
    String engine,
    bool draft,
    bool enableCache,
  });
}
