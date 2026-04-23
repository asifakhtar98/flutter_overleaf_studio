// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CacheStats {

 int get hits; int get misses; int get size;@JsonKey(name: 'max_size') int get maxSize;
/// Create a copy of CacheStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheStatsCopyWith<CacheStats> get copyWith => _$CacheStatsCopyWithImpl<CacheStats>(this as CacheStats, _$identity);

  /// Serializes this CacheStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheStats&&(identical(other.hits, hits) || other.hits == hits)&&(identical(other.misses, misses) || other.misses == misses)&&(identical(other.size, size) || other.size == size)&&(identical(other.maxSize, maxSize) || other.maxSize == maxSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hits,misses,size,maxSize);

@override
String toString() {
  return 'CacheStats(hits: $hits, misses: $misses, size: $size, maxSize: $maxSize)';
}


}

/// @nodoc
abstract mixin class $CacheStatsCopyWith<$Res>  {
  factory $CacheStatsCopyWith(CacheStats value, $Res Function(CacheStats) _then) = _$CacheStatsCopyWithImpl;
@useResult
$Res call({
 int hits, int misses, int size,@JsonKey(name: 'max_size') int maxSize
});




}
/// @nodoc
class _$CacheStatsCopyWithImpl<$Res>
    implements $CacheStatsCopyWith<$Res> {
  _$CacheStatsCopyWithImpl(this._self, this._then);

  final CacheStats _self;
  final $Res Function(CacheStats) _then;

/// Create a copy of CacheStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hits = null,Object? misses = null,Object? size = null,Object? maxSize = null,}) {
  return _then(_self.copyWith(
hits: null == hits ? _self.hits : hits // ignore: cast_nullable_to_non_nullable
as int,misses: null == misses ? _self.misses : misses // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,maxSize: null == maxSize ? _self.maxSize : maxSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CacheStats].
extension CacheStatsPatterns on CacheStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CacheStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CacheStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CacheStats value)  $default,){
final _that = this;
switch (_that) {
case _CacheStats():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CacheStats value)?  $default,){
final _that = this;
switch (_that) {
case _CacheStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hits,  int misses,  int size, @JsonKey(name: 'max_size')  int maxSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CacheStats() when $default != null:
return $default(_that.hits,_that.misses,_that.size,_that.maxSize);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hits,  int misses,  int size, @JsonKey(name: 'max_size')  int maxSize)  $default,) {final _that = this;
switch (_that) {
case _CacheStats():
return $default(_that.hits,_that.misses,_that.size,_that.maxSize);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hits,  int misses,  int size, @JsonKey(name: 'max_size')  int maxSize)?  $default,) {final _that = this;
switch (_that) {
case _CacheStats() when $default != null:
return $default(_that.hits,_that.misses,_that.size,_that.maxSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CacheStats implements CacheStats {
  const _CacheStats({this.hits = 0, this.misses = 0, this.size = 0, @JsonKey(name: 'max_size') this.maxSize = 200});
  factory _CacheStats.fromJson(Map<String, dynamic> json) => _$CacheStatsFromJson(json);

@override@JsonKey() final  int hits;
@override@JsonKey() final  int misses;
@override@JsonKey() final  int size;
@override@JsonKey(name: 'max_size') final  int maxSize;

/// Create a copy of CacheStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CacheStatsCopyWith<_CacheStats> get copyWith => __$CacheStatsCopyWithImpl<_CacheStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CacheStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CacheStats&&(identical(other.hits, hits) || other.hits == hits)&&(identical(other.misses, misses) || other.misses == misses)&&(identical(other.size, size) || other.size == size)&&(identical(other.maxSize, maxSize) || other.maxSize == maxSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hits,misses,size,maxSize);

@override
String toString() {
  return 'CacheStats(hits: $hits, misses: $misses, size: $size, maxSize: $maxSize)';
}


}

/// @nodoc
abstract mixin class _$CacheStatsCopyWith<$Res> implements $CacheStatsCopyWith<$Res> {
  factory _$CacheStatsCopyWith(_CacheStats value, $Res Function(_CacheStats) _then) = __$CacheStatsCopyWithImpl;
@override @useResult
$Res call({
 int hits, int misses, int size,@JsonKey(name: 'max_size') int maxSize
});




}
/// @nodoc
class __$CacheStatsCopyWithImpl<$Res>
    implements _$CacheStatsCopyWith<$Res> {
  __$CacheStatsCopyWithImpl(this._self, this._then);

  final _CacheStats _self;
  final $Res Function(_CacheStats) _then;

/// Create a copy of CacheStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hits = null,Object? misses = null,Object? size = null,Object? maxSize = null,}) {
  return _then(_CacheStats(
hits: null == hits ? _self.hits : hits // ignore: cast_nullable_to_non_nullable
as int,misses: null == misses ? _self.misses : misses // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,maxSize: null == maxSize ? _self.maxSize : maxSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
