import 'package:freezed_annotation/freezed_annotation.dart';

part 'compiler_event.freezed.dart';

@freezed
sealed class CompilerEvent with _$CompilerEvent {
  const factory CompilerEvent.compileRequested({
    required String engine,
    required bool draft,
  }) = CompileRequested;

  const factory CompilerEvent.reset() = CompileReset;
}
