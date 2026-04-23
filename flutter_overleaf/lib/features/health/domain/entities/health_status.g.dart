// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthStatus _$HealthStatusFromJson(Map<String, dynamic> json) =>
    _HealthStatus(
      status: json['status'] as String,
      texliveVersion: json['texlive_version'] as String,
      engines:
          (json['engines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      uptimeSeconds: (json['uptime_seconds'] as num?)?.toDouble() ?? 0,
      cacheStats: json['cache_stats'] == null
          ? null
          : CacheStats.fromJson(json['cache_stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HealthStatusToJson(_HealthStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'texlive_version': instance.texliveVersion,
      'engines': instance.engines,
      'uptime_seconds': instance.uptimeSeconds,
      'cache_stats': instance.cacheStats,
    };
