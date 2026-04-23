import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_overleaf/core/models/engine.dart';
import 'package:flutter_overleaf/features/compiler/domain/entities/compile_result.dart';

part 'compiler_state.freezed.dart';

@freezed
sealed class CompilerState with _$CompilerState {
  const factory CompilerState.initial() = CompilerInitial;

  const factory CompilerState.loading({required Engine engine}) =
      CompilerLoading;

  const factory CompilerState.success({required CompileResult result}) =
      CompilerSuccess;

  const factory CompilerState.failure({
    required String errorCode,
    required String log,
    double? compilationTime,
    String? requestId,
  }) = CompilerFailure;
}
