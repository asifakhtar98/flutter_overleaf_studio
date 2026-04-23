import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_overleaf/features/health/domain/entities/cache_stats.dart';

part 'health_status.freezed.dart';
part 'health_status.g.dart';

@freezed
sealed class HealthStatus with _$HealthStatus {
  const factory HealthStatus({
    required String status,
    @JsonKey(name: 'texlive_version') required String texliveVersion,
    @Default([]) List<String> engines,
    @JsonKey(name: 'uptime_seconds') @Default(0) double uptimeSeconds,
    @JsonKey(name: 'cache_stats') CacheStats? cacheStats,
  }) = _HealthStatus;

  factory HealthStatus.fromJson(Map<String, dynamic> json) =>
      _$HealthStatusFromJson(json);
}
