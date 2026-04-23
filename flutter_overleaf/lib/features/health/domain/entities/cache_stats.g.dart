// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CacheStats _$CacheStatsFromJson(Map<String, dynamic> json) => _CacheStats(
  hits: (json['hits'] as num?)?.toInt() ?? 0,
  misses: (json['misses'] as num?)?.toInt() ?? 0,
  size: (json['size'] as num?)?.toInt() ?? 0,
  maxSize: (json['max_size'] as num?)?.toInt() ?? 200,
);

Map<String, dynamic> _$CacheStatsToJson(_CacheStats instance) =>
    <String, dynamic>{
      'hits': instance.hits,
      'misses': instance.misses,
      'size': instance.size,
      'max_size': instance.maxSize,
    };
