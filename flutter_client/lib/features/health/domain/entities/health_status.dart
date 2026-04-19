import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_status.freezed.dart';
part 'health_status.g.dart';

@freezed
sealed class HealthStatus with _$HealthStatus {
  const factory HealthStatus({
    required String status,
    @JsonKey(name: 'texlive_version') required String texliveVersion,
    @JsonKey(name: 'cache_stats') Map<String, dynamic>? cacheStats,
  }) = _HealthStatus;

  factory HealthStatus.fromJson(Map<String, dynamic> json) =>
      _$HealthStatusFromJson(json);
}
