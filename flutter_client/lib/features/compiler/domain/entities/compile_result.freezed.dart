// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compile_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompileResult {

 Uint8List get pdfBytes; String get log; double get compilationTime; String get engine; int get warningsCount; int get passesRun; bool get cached;
/// Create a copy of CompileResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompileResultCopyWith<CompileResult> get copyWith => _$CompileResultCopyWithImpl<CompileResult>(this as CompileResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompileResult&&const DeepCollectionEquality().equals(other.pdfBytes, pdfBytes)&&(identical(other.log, log) || other.log == log)&&(identical(other.compilationTime, compilationTime) || other.compilationTime == compilationTime)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.warningsCount, warningsCount) || other.warningsCount == warningsCount)&&(identical(other.passesRun, passesRun) || other.passesRun == passesRun)&&(identical(other.cached, cached) || other.cached == cached));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pdfBytes),log,compilationTime,engine,warningsCount,passesRun,cached);

@override
String toString() {
  return 'CompileResult(pdfBytes: $pdfBytes, log: $log, compilationTime: $compilationTime, engine: $engine, warningsCount: $warningsCount, passesRun: $passesRun, cached: $cached)';
}


}

/// @nodoc
abstract mixin class $CompileResultCopyWith<$Res>  {
  factory $CompileResultCopyWith(CompileResult value, $Res Function(CompileResult) _then) = _$CompileResultCopyWithImpl;
@useResult
$Res call({
 Uint8List pdfBytes, String log, double compilationTime, String engine, int warningsCount, int passesRun, bool cached
});




}
/// @nodoc
class _$CompileResultCopyWithImpl<$Res>
    implements $CompileResultCopyWith<$Res> {
  _$CompileResultCopyWithImpl(this._self, this._then);

  final CompileResult _self;
  final $Res Function(CompileResult) _then;

/// Create a copy of CompileResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pdfBytes = null,Object? log = null,Object? compilationTime = null,Object? engine = null,Object? warningsCount = null,Object? passesRun = null,Object? cached = null,}) {
  return _then(_self.copyWith(
pdfBytes: null == pdfBytes ? _self.pdfBytes : pdfBytes // ignore: cast_nullable_to_non_nullable
as Uint8List,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,compilationTime: null == compilationTime ? _self.compilationTime : compilationTime // ignore: cast_nullable_to_non_nullable
as double,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,warningsCount: null == warningsCount ? _self.warningsCount : warningsCount // ignore: cast_nullable_to_non_nullable
as int,passesRun: null == passesRun ? _self.passesRun : passesRun // ignore: cast_nullable_to_non_nullable
as int,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CompileResult].
extension CompileResultPatterns on CompileResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompileResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompileResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompileResult value)  $default,){
final _that = this;
switch (_that) {
case _CompileResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompileResult value)?  $default,){
final _that = this;
switch (_that) {
case _CompileResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List pdfBytes,  String log,  double compilationTime,  String engine,  int warningsCount,  int passesRun,  bool cached)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompileResult() when $default != null:
return $default(_that.pdfBytes,_that.log,_that.compilationTime,_that.engine,_that.warningsCount,_that.passesRun,_that.cached);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List pdfBytes,  String log,  double compilationTime,  String engine,  int warningsCount,  int passesRun,  bool cached)  $default,) {final _that = this;
switch (_that) {
case _CompileResult():
return $default(_that.pdfBytes,_that.log,_that.compilationTime,_that.engine,_that.warningsCount,_that.passesRun,_that.cached);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List pdfBytes,  String log,  double compilationTime,  String engine,  int warningsCount,  int passesRun,  bool cached)?  $default,) {final _that = this;
switch (_that) {
case _CompileResult() when $default != null:
return $default(_that.pdfBytes,_that.log,_that.compilationTime,_that.engine,_that.warningsCount,_that.passesRun,_that.cached);case _:
  return null;

}
}

}

/// @nodoc


class _CompileResult implements CompileResult {
  const _CompileResult({required this.pdfBytes, required this.log, required this.compilationTime, required this.engine, required this.warningsCount, required this.passesRun, required this.cached});
  

@override final  Uint8List pdfBytes;
@override final  String log;
@override final  double compilationTime;
@override final  String engine;
@override final  int warningsCount;
@override final  int passesRun;
@override final  bool cached;

/// Create a copy of CompileResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompileResultCopyWith<_CompileResult> get copyWith => __$CompileResultCopyWithImpl<_CompileResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompileResult&&const DeepCollectionEquality().equals(other.pdfBytes, pdfBytes)&&(identical(other.log, log) || other.log == log)&&(identical(other.compilationTime, compilationTime) || other.compilationTime == compilationTime)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.warningsCount, warningsCount) || other.warningsCount == warningsCount)&&(identical(other.passesRun, passesRun) || other.passesRun == passesRun)&&(identical(other.cached, cached) || other.cached == cached));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pdfBytes),log,compilationTime,engine,warningsCount,passesRun,cached);

@override
String toString() {
  return 'CompileResult(pdfBytes: $pdfBytes, log: $log, compilationTime: $compilationTime, engine: $engine, warningsCount: $warningsCount, passesRun: $passesRun, cached: $cached)';
}


}

/// @nodoc
abstract mixin class _$CompileResultCopyWith<$Res> implements $CompileResultCopyWith<$Res> {
  factory _$CompileResultCopyWith(_CompileResult value, $Res Function(_CompileResult) _then) = __$CompileResultCopyWithImpl;
@override @useResult
$Res call({
 Uint8List pdfBytes, String log, double compilationTime, String engine, int warningsCount, int passesRun, bool cached
});




}
/// @nodoc
class __$CompileResultCopyWithImpl<$Res>
    implements _$CompileResultCopyWith<$Res> {
  __$CompileResultCopyWithImpl(this._self, this._then);

  final _CompileResult _self;
  final $Res Function(_CompileResult) _then;

/// Create a copy of CompileResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pdfBytes = null,Object? log = null,Object? compilationTime = null,Object? engine = null,Object? warningsCount = null,Object? passesRun = null,Object? cached = null,}) {
  return _then(_CompileResult(
pdfBytes: null == pdfBytes ? _self.pdfBytes : pdfBytes // ignore: cast_nullable_to_non_nullable
as Uint8List,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,compilationTime: null == compilationTime ? _self.compilationTime : compilationTime // ignore: cast_nullable_to_non_nullable
as double,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,warningsCount: null == warningsCount ? _self.warningsCount : warningsCount // ignore: cast_nullable_to_non_nullable
as int,passesRun: null == passesRun ? _self.passesRun : passesRun // ignore: cast_nullable_to_non_nullable
as int,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
