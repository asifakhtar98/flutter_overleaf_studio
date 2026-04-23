import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache_stats.freezed.dart';
part 'cache_stats.g.dart';

@freezed
sealed class CacheStats with _$CacheStats {
  const factory CacheStats({
    @Default(0) int hits,
    @Default(0) int misses,
    @Default(0) int size,
    @JsonKey(name: 'max_size') @Default(200) int maxSize,
  }) = _CacheStats;

  factory CacheStats.fromJson(Map<String, dynamic> json) =>
      _$CacheStatsFromJson(json);
}
