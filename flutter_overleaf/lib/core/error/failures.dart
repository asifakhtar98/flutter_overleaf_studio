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
    String? requestId,
  }) = CompilationFailure;

  const factory Failure.validation({required String message}) =
      ValidationFailure;

  const factory Failure.auth({
    required String message,
    required String errorCode,
    String? requestId,
  }) = AuthFailure;

  const factory Failure.rateLimited({
    required String message,
    String? requestId,
  }) = RateLimitedFailure;

  const factory Failure.uploadTooLarge({
    required String message,
    String? requestId,
  }) = UploadTooLargeFailure;

  const factory Failure.unknown({String? message}) = UnknownFailure;
}
