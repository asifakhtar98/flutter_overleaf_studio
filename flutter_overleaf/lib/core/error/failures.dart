import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.server({required String message, String? errorCode}) =
      ServerFailure;

  const factory Failure.network({required String message}) = NetworkFailure;

  const factory Failure.compilation({
    required String log,
    required String errorCode,
    double? compilationTime,
  }) = CompilationFailure;

  const factory Failure.validation({required String message}) =
      ValidationFailure;

  const factory Failure.unknown({String? message}) = UnknownFailure;
}
