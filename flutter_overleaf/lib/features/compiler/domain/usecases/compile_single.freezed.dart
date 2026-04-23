// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compile_single.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompileSingleParams {

 String get source; Engine get engine; bool get draft; bool get enableCache;
/// Create a copy of CompileSingleParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompileSingleParamsCopyWith<CompileSingleParams> get copyWith => _$CompileSingleParamsCopyWithImpl<CompileSingleParams>(this as CompileSingleParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompileSingleParams&&(identical(other.source, source) || other.source == source)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.enableCache, enableCache) || other.enableCache == enableCache));
}


@override
int get hashCode => Object.hash(runtimeType,source,engine,draft,enableCache);

@override
String toString() {
  return 'CompileSingleParams(source: $source, engine: $engine, draft: $draft, enableCache: $enableCache)';
}


}

/// @nodoc
abstract mixin class $CompileSingleParamsCopyWith<$Res>  {
  factory $CompileSingleParamsCopyWith(CompileSingleParams value, $Res Function(CompileSingleParams) _then) = _$CompileSingleParamsCopyWithImpl;
@useResult
$Res call({
 String source, Engine engine, bool draft, bool enableCache
});




}
/// @nodoc
class _$CompileSingleParamsCopyWithImpl<$Res>
    implements $CompileSingleParamsCopyWith<$Res> {
  _$CompileSingleParamsCopyWithImpl(this._self, this._then);

  final CompileSingleParams _self;
  final $Res Function(CompileSingleParams) _then;

/// Create a copy of CompileSingleParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? engine = null,Object? draft = null,Object? enableCache = null,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as Engine,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,enableCache: null == enableCache ? _self.enableCache : enableCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CompileSingleParams].
extension CompileSingleParamsPatterns on CompileSingleParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompileSingleParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompileSingleParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompileSingleParams value)  $default,){
final _that = this;
switch (_that) {
case _CompileSingleParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompileSingleParams value)?  $default,){
final _that = this;
switch (_that) {
case _CompileSingleParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String source,  Engine engine,  bool draft,  bool enableCache)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompileSingleParams() when $default != null:
return $default(_that.source,_that.engine,_that.draft,_that.enableCache);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String source,  Engine engine,  bool draft,  bool enableCache)  $default,) {final _that = this;
switch (_that) {
case _CompileSingleParams():
return $default(_that.source,_that.engine,_that.draft,_that.enableCache);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String source,  Engine engine,  bool draft,  bool enableCache)?  $default,) {final _that = this;
switch (_that) {
case _CompileSingleParams() when $default != null:
return $default(_that.source,_that.engine,_that.draft,_that.enableCache);case _:
  return null;

}
}

}

/// @nodoc


class _CompileSingleParams implements CompileSingleParams {
  const _CompileSingleParams({required this.source, this.engine = Engine.pdflatex, this.draft = false, this.enableCache = true});
  

@override final  String source;
@override@JsonKey() final  Engine engine;
@override@JsonKey() final  bool draft;
@override@JsonKey() final  bool enableCache;

/// Create a copy of CompileSingleParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompileSingleParamsCopyWith<_CompileSingleParams> get copyWith => __$CompileSingleParamsCopyWithImpl<_CompileSingleParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompileSingleParams&&(identical(other.source, source) || other.source == source)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.enableCache, enableCache) || other.enableCache == enableCache));
}


@override
int get hashCode => Object.hash(runtimeType,source,engine,draft,enableCache);

@override
String toString() {
  return 'CompileSingleParams(source: $source, engine: $engine, draft: $draft, enableCache: $enableCache)';
}


}

/// @nodoc
abstract mixin class _$CompileSingleParamsCopyWith<$Res> implements $CompileSingleParamsCopyWith<$Res> {
  factory _$CompileSingleParamsCopyWith(_CompileSingleParams value, $Res Function(_CompileSingleParams) _then) = __$CompileSingleParamsCopyWithImpl;
@override @useResult
$Res call({
 String source, Engine engine, bool draft, bool enableCache
});




}
/// @nodoc
class __$CompileSingleParamsCopyWithImpl<$Res>
    implements _$CompileSingleParamsCopyWith<$Res> {
  __$CompileSingleParamsCopyWithImpl(this._self, this._then);

  final _CompileSingleParams _self;
  final $Res Function(_CompileSingleParams) _then;

/// Create a copy of CompileSingleParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? engine = null,Object? draft = null,Object? enableCache = null,}) {
  return _then(_CompileSingleParams(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as Engine,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,enableCache: null == enableCache ? _self.enableCache : enableCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
