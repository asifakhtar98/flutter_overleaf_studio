// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure()';
}


}

/// @nodoc
class $FailureCopyWith<$Res>  {
$FailureCopyWith(Failure _, $Res Function(Failure) __);
}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ServerFailure value)?  server,TResult Function( NetworkFailure value)?  network,TResult Function( CompilationFailure value)?  compilation,TResult Function( ValidationFailure value)?  validation,TResult Function( AuthFailure value)?  auth,TResult Function( RateLimitedFailure value)?  rateLimited,TResult Function( UploadTooLargeFailure value)?  uploadTooLarge,TResult Function( UnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that);case NetworkFailure() when network != null:
return network(_that);case CompilationFailure() when compilation != null:
return compilation(_that);case ValidationFailure() when validation != null:
return validation(_that);case AuthFailure() when auth != null:
return auth(_that);case RateLimitedFailure() when rateLimited != null:
return rateLimited(_that);case UploadTooLargeFailure() when uploadTooLarge != null:
return uploadTooLarge(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ServerFailure value)  server,required TResult Function( NetworkFailure value)  network,required TResult Function( CompilationFailure value)  compilation,required TResult Function( ValidationFailure value)  validation,required TResult Function( AuthFailure value)  auth,required TResult Function( RateLimitedFailure value)  rateLimited,required TResult Function( UploadTooLargeFailure value)  uploadTooLarge,required TResult Function( UnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case ServerFailure():
return server(_that);case NetworkFailure():
return network(_that);case CompilationFailure():
return compilation(_that);case ValidationFailure():
return validation(_that);case AuthFailure():
return auth(_that);case RateLimitedFailure():
return rateLimited(_that);case UploadTooLargeFailure():
return uploadTooLarge(_that);case UnknownFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ServerFailure value)?  server,TResult? Function( NetworkFailure value)?  network,TResult? Function( CompilationFailure value)?  compilation,TResult? Function( ValidationFailure value)?  validation,TResult? Function( AuthFailure value)?  auth,TResult? Function( RateLimitedFailure value)?  rateLimited,TResult? Function( UploadTooLargeFailure value)?  uploadTooLarge,TResult? Function( UnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that);case NetworkFailure() when network != null:
return network(_that);case CompilationFailure() when compilation != null:
return compilation(_that);case ValidationFailure() when validation != null:
return validation(_that);case AuthFailure() when auth != null:
return auth(_that);case RateLimitedFailure() when rateLimited != null:
return rateLimited(_that);case UploadTooLargeFailure() when uploadTooLarge != null:
return uploadTooLarge(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  String? errorCode)?  server,TResult Function( String message)?  network,TResult Function( String log,  String errorCode,  double? compilationTime,  String? requestId)?  compilation,TResult Function( String message)?  validation,TResult Function( String message,  String errorCode,  String? requestId)?  auth,TResult Function( String message,  String? requestId)?  rateLimited,TResult Function( String message,  String? requestId)?  uploadTooLarge,TResult Function( String? message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that.message,_that.errorCode);case NetworkFailure() when network != null:
return network(_that.message);case CompilationFailure() when compilation != null:
return compilation(_that.log,_that.errorCode,_that.compilationTime,_that.requestId);case ValidationFailure() when validation != null:
return validation(_that.message);case AuthFailure() when auth != null:
return auth(_that.message,_that.errorCode,_that.requestId);case RateLimitedFailure() when rateLimited != null:
return rateLimited(_that.message,_that.requestId);case UploadTooLargeFailure() when uploadTooLarge != null:
return uploadTooLarge(_that.message,_that.requestId);case UnknownFailure() when unknown != null:
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  String? errorCode)  server,required TResult Function( String message)  network,required TResult Function( String log,  String errorCode,  double? compilationTime,  String? requestId)  compilation,required TResult Function( String message)  validation,required TResult Function( String message,  String errorCode,  String? requestId)  auth,required TResult Function( String message,  String? requestId)  rateLimited,required TResult Function( String message,  String? requestId)  uploadTooLarge,required TResult Function( String? message)  unknown,}) {final _that = this;
switch (_that) {
case ServerFailure():
return server(_that.message,_that.errorCode);case NetworkFailure():
return network(_that.message);case CompilationFailure():
return compilation(_that.log,_that.errorCode,_that.compilationTime,_that.requestId);case ValidationFailure():
return validation(_that.message);case AuthFailure():
return auth(_that.message,_that.errorCode,_that.requestId);case RateLimitedFailure():
return rateLimited(_that.message,_that.requestId);case UploadTooLargeFailure():
return uploadTooLarge(_that.message,_that.requestId);case UnknownFailure():
return unknown(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  String? errorCode)?  server,TResult? Function( String message)?  network,TResult? Function( String log,  String errorCode,  double? compilationTime,  String? requestId)?  compilation,TResult? Function( String message)?  validation,TResult? Function( String message,  String errorCode,  String? requestId)?  auth,TResult? Function( String message,  String? requestId)?  rateLimited,TResult? Function( String message,  String? requestId)?  uploadTooLarge,TResult? Function( String? message)?  unknown,}) {final _that = this;
switch (_that) {
case ServerFailure() when server != null:
return server(_that.message,_that.errorCode);case NetworkFailure() when network != null:
return network(_that.message);case CompilationFailure() when compilation != null:
return compilation(_that.log,_that.errorCode,_that.compilationTime,_that.requestId);case ValidationFailure() when validation != null:
return validation(_that.message);case AuthFailure() when auth != null:
return auth(_that.message,_that.errorCode,_that.requestId);case RateLimitedFailure() when rateLimited != null:
return rateLimited(_that.message,_that.requestId);case UploadTooLargeFailure() when uploadTooLarge != null:
return uploadTooLarge(_that.message,_that.requestId);case UnknownFailure() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ServerFailure implements Failure {
  const ServerFailure({required this.message, this.errorCode});
  

 final  String message;
 final  String? errorCode;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,errorCode);

@override
String toString() {
  return 'Failure.server(message: $message, errorCode: $errorCode)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@useResult
$Res call({
 String message, String? errorCode
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errorCode = freezed,}) {
  return _then(ServerFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class NetworkFailure implements Failure {
  const NetworkFailure({required this.message});
  

 final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.network(message: $message)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NetworkFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CompilationFailure implements Failure {
  const CompilationFailure({required this.log, required this.errorCode, this.compilationTime, this.requestId});
  

 final  String log;
 final  String errorCode;
 final  double? compilationTime;
 final  String? requestId;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompilationFailureCopyWith<CompilationFailure> get copyWith => _$CompilationFailureCopyWithImpl<CompilationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompilationFailure&&(identical(other.log, log) || other.log == log)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.compilationTime, compilationTime) || other.compilationTime == compilationTime)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}


@override
int get hashCode => Object.hash(runtimeType,log,errorCode,compilationTime,requestId);

@override
String toString() {
  return 'Failure.compilation(log: $log, errorCode: $errorCode, compilationTime: $compilationTime, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $CompilationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $CompilationFailureCopyWith(CompilationFailure value, $Res Function(CompilationFailure) _then) = _$CompilationFailureCopyWithImpl;
@useResult
$Res call({
 String log, String errorCode, double? compilationTime, String? requestId
});




}
/// @nodoc
class _$CompilationFailureCopyWithImpl<$Res>
    implements $CompilationFailureCopyWith<$Res> {
  _$CompilationFailureCopyWithImpl(this._self, this._then);

  final CompilationFailure _self;
  final $Res Function(CompilationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? log = null,Object? errorCode = null,Object? compilationTime = freezed,Object? requestId = freezed,}) {
  return _then(CompilationFailure(
log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String,errorCode: null == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String,compilationTime: freezed == compilationTime ? _self.compilationTime : compilationTime // ignore: cast_nullable_to_non_nullable
as double?,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ValidationFailure implements Failure {
  const ValidationFailure({required this.message});
  

 final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.validation(message: $message)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ValidationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthFailure implements Failure {
  const AuthFailure({required this.message, required this.errorCode, this.requestId});
  

 final  String message;
 final  String errorCode;
 final  String? requestId;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthFailureCopyWith<AuthFailure> get copyWith => _$AuthFailureCopyWithImpl<AuthFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}


@override
int get hashCode => Object.hash(runtimeType,message,errorCode,requestId);

@override
String toString() {
  return 'Failure.auth(message: $message, errorCode: $errorCode, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $AuthFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $AuthFailureCopyWith(AuthFailure value, $Res Function(AuthFailure) _then) = _$AuthFailureCopyWithImpl;
@useResult
$Res call({
 String message, String errorCode, String? requestId
});




}
/// @nodoc
class _$AuthFailureCopyWithImpl<$Res>
    implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._self, this._then);

  final AuthFailure _self;
  final $Res Function(AuthFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errorCode = null,Object? requestId = freezed,}) {
  return _then(AuthFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errorCode: null == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RateLimitedFailure implements Failure {
  const RateLimitedFailure({required this.message, this.requestId});
  

 final  String message;
 final  String? requestId;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RateLimitedFailureCopyWith<RateLimitedFailure> get copyWith => _$RateLimitedFailureCopyWithImpl<RateLimitedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RateLimitedFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}


@override
int get hashCode => Object.hash(runtimeType,message,requestId);

@override
String toString() {
  return 'Failure.rateLimited(message: $message, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $RateLimitedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $RateLimitedFailureCopyWith(RateLimitedFailure value, $Res Function(RateLimitedFailure) _then) = _$RateLimitedFailureCopyWithImpl;
@useResult
$Res call({
 String message, String? requestId
});




}
/// @nodoc
class _$RateLimitedFailureCopyWithImpl<$Res>
    implements $RateLimitedFailureCopyWith<$Res> {
  _$RateLimitedFailureCopyWithImpl(this._self, this._then);

  final RateLimitedFailure _self;
  final $Res Function(RateLimitedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? requestId = freezed,}) {
  return _then(RateLimitedFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UploadTooLargeFailure implements Failure {
  const UploadTooLargeFailure({required this.message, this.requestId});
  

 final  String message;
 final  String? requestId;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadTooLargeFailureCopyWith<UploadTooLargeFailure> get copyWith => _$UploadTooLargeFailureCopyWithImpl<UploadTooLargeFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadTooLargeFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}


@override
int get hashCode => Object.hash(runtimeType,message,requestId);

@override
String toString() {
  return 'Failure.uploadTooLarge(message: $message, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $UploadTooLargeFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UploadTooLargeFailureCopyWith(UploadTooLargeFailure value, $Res Function(UploadTooLargeFailure) _then) = _$UploadTooLargeFailureCopyWithImpl;
@useResult
$Res call({
 String message, String? requestId
});




}
/// @nodoc
class _$UploadTooLargeFailureCopyWithImpl<$Res>
    implements $UploadTooLargeFailureCopyWith<$Res> {
  _$UploadTooLargeFailureCopyWithImpl(this._self, this._then);

  final UploadTooLargeFailure _self;
  final $Res Function(UploadTooLargeFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? requestId = freezed,}) {
  return _then(UploadTooLargeFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnknownFailure implements Failure {
  const UnknownFailure({this.message});
  

 final  String? message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownFailureCopyWith<UnknownFailure> get copyWith => _$UnknownFailureCopyWithImpl<UnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnknownFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnknownFailureCopyWith(UnknownFailure value, $Res Function(UnknownFailure) _then) = _$UnknownFailureCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$UnknownFailureCopyWithImpl<$Res>
    implements $UnknownFailureCopyWith<$Res> {
  _$UnknownFailureCopyWithImpl(this._self, this._then);

  final UnknownFailure _self;
  final $Res Function(UnknownFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(UnknownFailure(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
