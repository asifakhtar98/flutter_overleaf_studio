// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthStatus _$HealthStatusFromJson(Map<String, dynamic> json) =>
    _HealthStatus(
      status: json['status'] as String,
      texliveVersion: json['texlive_version'] as String,
      cacheStats: json['cache_stats'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HealthStatusToJson(_HealthStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'texlive_version': instance.texliveVersion,
      'cache_stats': instance.cacheStats,
    };
