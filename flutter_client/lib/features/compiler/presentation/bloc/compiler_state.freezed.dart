// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compiler_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompilerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompilerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompilerState()';
}


}

/// @nodoc
class $CompilerStateCopyWith<$Res>  {
$CompilerStateCopyWith(CompilerState _, $Res Function(CompilerState) __);
}


/// Adds pattern-matching-related methods to [CompilerState].
extension CompilerStatePatterns on CompilerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CompilerInitial value)?  initial,TResult Function( CompilerLoading value)?  loading,TResult Function( CompilerSuccess value)?  success,TResult Function( CompilerFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CompilerInitial() when initial != null:
return initial(_that);case CompilerLoading() when loading != null:
return loading(_that);case CompilerSuccess() when success != null:
return success(_that);case CompilerFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CompilerInitial value)  initial,required TResult Function( CompilerLoading value)  loading,required TResult Function( CompilerSuccess value)  success,required TResult Function( CompilerFailure value)  failure,}){
final _that = this;
switch (_that) {
case CompilerInitial():
return initial(_that);case CompilerLoading():
return loading(_that);case CompilerSuccess():
return success(_that);case CompilerFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CompilerInitial value)?  initial,TResult? Function( CompilerLoading value)?  loading,TResult? Function( CompilerSuccess value)?  success,TResult? Function( CompilerFailure value)?  failure,}){
final _that = this;
switch (_that) {
case CompilerInitial() when initial != null:
return initial(_that);case CompilerLoading() when loading != null:
return loading(_that);case CompilerSuccess() when success != null:
return success(_that);case CompilerFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String engine)?  loading,TResult Function( CompileResult result)?  success,TResult Function( String errorCode,  String log,  double? compilationTime)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CompilerInitial() when initial != null:
return initial();case CompilerLoading() when loading != null:
return loading(_that.engine);case CompilerSuccess() when success != null:
return success(_that.result);case CompilerFailure() when failure != null:
return failure(_that.errorCode,_that.log,_that.compilationTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String engine)  loading,required TResult Function( CompileResult result)  success,required TResult Function( String errorCode,  String log,  double? compilationTime)  failure,}) {final _that = this;
switch (_that) {
case CompilerInitial():
return initial();case CompilerLoading():
return loading(_that.engine);case CompilerSuccess():
return success(_that.result);case CompilerFailure():
return failure(_that.errorCode,_that.log,_that.compilationTime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String engine)?  loading,TResult? Function( CompileResult result)?  success,TResult? Function( String errorCode,  String log,  double? compilationTime)?  failure,}) {final _that = this;
switch (_that) {
case CompilerInitial() when initial != null:
return initial();case CompilerLoading() when loading != null:
return loading(_that.engine);case CompilerSuccess() when success != null:
return success(_that.result);case CompilerFailure() when failure != null:
return failure(_that.errorCode,_that.log,_that.compilationTime);case _:
  return null;

}
}

}

/// @nodoc


class CompilerInitial implements CompilerState {
  const CompilerInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompilerInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompilerState.initial()';
}


}




/// @nodoc


class CompilerLoading implements CompilerState {
  const CompilerLoading({required this.engine});
  

 final  String engine;

/// Create a copy of CompilerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompilerLoadingCopyWith<CompilerLoading> get copyWith => _$CompilerLoadingCopyWithImpl<CompilerLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompilerLoading&&(identical(other.engine, engine) || other.engine == engine));
}


@override
int get hashCode => Object.hash(runtimeType,engine);

@override
String toString() {
  return 'CompilerState.loading(engine: $engine)';
}


}

/// @nodoc
abstract mixin class $CompilerLoadingCopyWith<$Res> implements $CompilerStateCopyWith<$Res> {
  factory $CompilerLoadingCopyWith(CompilerLoading value, $Res Function(CompilerLoading) _then) = _$CompilerLoadingCopyWithImpl;
@useResult
$Res call({
 String engine
});




}
/// @nodoc
class _$CompilerLoadingCopyWithImpl<$Res>
    implements $CompilerLoadingCopyWith<$Res> {
  _$CompilerLoadingCopyWithImpl(this._self, this._then);

  final CompilerLoading _self;
  final $Res Function(CompilerLoading) _then;

/// Create a copy of CompilerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? engine = null,}) {
  return _then(CompilerLoading(
engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CompilerSuccess implements CompilerState {
  const CompilerSuccess({required this.result});
  

 final  CompileResult result;

/// Create a copy of CompilerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompilerSuccessCopyWith<CompilerSuccess> get copyWith => _$CompilerSuccessCopyWithImpl<CompilerSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompilerSuccess&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,result);

@override
String toString() {
  return 'CompilerState.success(result: $result)';
}


}

/// @nodoc
abstract mixin class $CompilerSuccessCopyWith<$Res> implements $CompilerStateCopyWith<$Res> {
  factory $CompilerSuccessCopyWith(CompilerSuccess value, $Res Function(CompilerSuccess) _then) = _$CompilerSuccessCopyWithImpl;
@useResult
$Res call({
 CompileResult result
});


$CompileResultCopyWith<$Res> get result;

}
/// @nodoc
class _$CompilerSuccessCopyWithImpl<$Res>
    implements $CompilerSuccessCopyWith<$Res> {
  _$CompilerSuccessCopyWithImpl(this._self, this._then);

  final CompilerSuccess _self;
  final $Res Function(CompilerSuccess) _then;

/// Create a copy of CompilerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,}) {
  return _then(CompilerSuccess(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as CompileResult,
  ));
}

/// Create a copy of CompilerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompileResultCopyWith<$Res> get result {
  
  return $CompileResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

/// @nodoc


class CompilerFailure implements CompilerState {
  const CompilerFailure({required this.errorCode, required this.log, this.compilationTime});
  

 final  String errorCode;
 final  String log;
 final  double? compilationTime;

/// Create a copy of CompilerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompilerFailureCopyWith<CompilerFailure> get copyWith => _$CompilerFailureCopyWithImpl<CompilerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompilerFailure&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.log, log) || other.log == log)&&(identical(other.compilationTime, compilationTime) || other.compilationTime == compilationTime));
}


@override
int get hashCode => Object.hash(runtimeType,errorCode,log,compilationTime);

@override
String toString() {
  return 'CompilerState.failure(errorCode: $errorCode, log: $log, compilationTime: $compilationTime)';
}


}

/// @nodoc
abstract mixin class $CompilerFailureCopyWith<$Res> implements $CompilerStateCopyWith<$Res> {
  factory $CompilerFailureCopyWith(CompilerFailure value, $Res Function(CompilerFailure) _then) = _$CompilerFailureCopyWithImpl;
@useResult
$Res call({
 String errorCode, String log, double? compilationTime
});




}
/// @nodoc
class _$CompilerFailureCopyWithImpl<$Res>
    implements $CompilerFailureCopyWith<$Res> {
  _$CompilerFailureCopyWithImpl(this._self, this._then);

  final CompilerFailure _self;
  final $Res Function(CompilerFailure) _then;

/// Create a copy of CompilerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorCode = null,Object? log = null,Object? compilationTime = freezed,}) {
  return _then(CompilerFailure(
errorCode: null == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,compilationTime: freezed == compilationTime ? _self.compilationTime : compilationTime // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
