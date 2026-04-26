// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HealthState()';
}


}

/// @nodoc
class $HealthStateCopyWith<$Res>  {
$HealthStateCopyWith(HealthState _, $Res Function(HealthState) __);
}


/// Adds pattern-matching-related methods to [HealthState].
extension HealthStatePatterns on HealthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HealthUnknown value)?  unknown,TResult Function( HealthChecking value)?  checking,TResult Function( HealthConnected value)?  connected,TResult Function( HealthDisconnected value)?  disconnected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HealthUnknown() when unknown != null:
return unknown(_that);case HealthChecking() when checking != null:
return checking(_that);case HealthConnected() when connected != null:
return connected(_that);case HealthDisconnected() when disconnected != null:
return disconnected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HealthUnknown value)  unknown,required TResult Function( HealthChecking value)  checking,required TResult Function( HealthConnected value)  connected,required TResult Function( HealthDisconnected value)  disconnected,}){
final _that = this;
switch (_that) {
case HealthUnknown():
return unknown(_that);case HealthChecking():
return checking(_that);case HealthConnected():
return connected(_that);case HealthDisconnected():
return disconnected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HealthUnknown value)?  unknown,TResult? Function( HealthChecking value)?  checking,TResult? Function( HealthConnected value)?  connected,TResult? Function( HealthDisconnected value)?  disconnected,}){
final _that = this;
switch (_that) {
case HealthUnknown() when unknown != null:
return unknown(_that);case HealthChecking() when checking != null:
return checking(_that);case HealthConnected() when connected != null:
return connected(_that);case HealthDisconnected() when disconnected != null:
return disconnected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function()?  checking,TResult Function( HealthStatus status)?  connected,TResult Function( String message)?  disconnected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HealthUnknown() when unknown != null:
return unknown();case HealthChecking() when checking != null:
return checking();case HealthConnected() when connected != null:
return connected(_that.status);case HealthDisconnected() when disconnected != null:
return disconnected(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function()  checking,required TResult Function( HealthStatus status)  connected,required TResult Function( String message)  disconnected,}) {final _that = this;
switch (_that) {
case HealthUnknown():
return unknown();case HealthChecking():
return checking();case HealthConnected():
return connected(_that.status);case HealthDisconnected():
return disconnected(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function()?  checking,TResult? Function( HealthStatus status)?  connected,TResult? Function( String message)?  disconnected,}) {final _that = this;
switch (_that) {
case HealthUnknown() when unknown != null:
return unknown();case HealthChecking() when checking != null:
return checking();case HealthConnected() when connected != null:
return connected(_that.status);case HealthDisconnected() when disconnected != null:
return disconnected(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HealthUnknown implements HealthState {
  const HealthUnknown();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HealthState.unknown()';
}


}




/// @nodoc


class HealthChecking implements HealthState {
  const HealthChecking();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthChecking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HealthState.checking()';
}


}




/// @nodoc


class HealthConnected implements HealthState {
  const HealthConnected({required this.status});
  

 final  HealthStatus status;

/// Create a copy of HealthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthConnectedCopyWith<HealthConnected> get copyWith => _$HealthConnectedCopyWithImpl<HealthConnected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthConnected&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'HealthState.connected(status: $status)';
}


}

/// @nodoc
abstract mixin class $HealthConnectedCopyWith<$Res> implements $HealthStateCopyWith<$Res> {
  factory $HealthConnectedCopyWith(HealthConnected value, $Res Function(HealthConnected) _then) = _$HealthConnectedCopyWithImpl;
@useResult
$Res call({
 HealthStatus status
});


$HealthStatusCopyWith<$Res> get status;

}
/// @nodoc
class _$HealthConnectedCopyWithImpl<$Res>
    implements $HealthConnectedCopyWith<$Res> {
  _$HealthConnectedCopyWithImpl(this._self, this._then);

  final HealthConnected _self;
  final $Res Function(HealthConnected) _then;

/// Create a copy of HealthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(HealthConnected(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthStatus,
  ));
}

/// Create a copy of HealthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthStatusCopyWith<$Res> get status {
  
  return $HealthStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

/// @nodoc


class HealthDisconnected implements HealthState {
  const HealthDisconnected({required this.message});
  

 final  String message;

/// Create a copy of HealthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthDisconnectedCopyWith<HealthDisconnected> get copyWith => _$HealthDisconnectedCopyWithImpl<HealthDisconnected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthDisconnected&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HealthState.disconnected(message: $message)';
}


}

/// @nodoc
abstract mixin class $HealthDisconnectedCopyWith<$Res> implements $HealthStateCopyWith<$Res> {
  factory $HealthDisconnectedCopyWith(HealthDisconnected value, $Res Function(HealthDisconnected) _then) = _$HealthDisconnectedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HealthDisconnectedCopyWithImpl<$Res>
    implements $HealthDisconnectedCopyWith<$Res> {
  _$HealthDisconnectedCopyWithImpl(this._self, this._then);

  final HealthDisconnected _self;
  final $Res Function(HealthDisconnected) _then;

/// Create a copy of HealthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HealthDisconnected(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
