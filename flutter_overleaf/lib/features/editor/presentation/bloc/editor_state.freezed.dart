// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorState {

 String get content; List<String> get openTabs; String? get currentTabPath; int? get targetLine;
/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorStateCopyWith<EditorState> get copyWith => _$EditorStateCopyWithImpl<EditorState>(this as EditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorState&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.openTabs, openTabs)&&(identical(other.currentTabPath, currentTabPath) || other.currentTabPath == currentTabPath)&&(identical(other.targetLine, targetLine) || other.targetLine == targetLine));
}


@override
int get hashCode => Object.hash(runtimeType,content,const DeepCollectionEquality().hash(openTabs),currentTabPath,targetLine);

@override
String toString() {
  return 'EditorState(content: $content, openTabs: $openTabs, currentTabPath: $currentTabPath, targetLine: $targetLine)';
}


}

/// @nodoc
abstract mixin class $EditorStateCopyWith<$Res>  {
  factory $EditorStateCopyWith(EditorState value, $Res Function(EditorState) _then) = _$EditorStateCopyWithImpl;
@useResult
$Res call({
 String content, List<String> openTabs, String? currentTabPath, int? targetLine
});




}
/// @nodoc
class _$EditorStateCopyWithImpl<$Res>
    implements $EditorStateCopyWith<$Res> {
  _$EditorStateCopyWithImpl(this._self, this._then);

  final EditorState _self;
  final $Res Function(EditorState) _then;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? openTabs = null,Object? currentTabPath = freezed,Object? targetLine = freezed,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,openTabs: null == openTabs ? _self.openTabs : openTabs // ignore: cast_nullable_to_non_nullable
as List<String>,currentTabPath: freezed == currentTabPath ? _self.currentTabPath : currentTabPath // ignore: cast_nullable_to_non_nullable
as String?,targetLine: freezed == targetLine ? _self.targetLine : targetLine // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditorState].
extension EditorStatePatterns on EditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorState value)  $default,){
final _that = this;
switch (_that) {
case _EditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorState value)?  $default,){
final _that = this;
switch (_that) {
case _EditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  List<String> openTabs,  String? currentTabPath,  int? targetLine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that.content,_that.openTabs,_that.currentTabPath,_that.targetLine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  List<String> openTabs,  String? currentTabPath,  int? targetLine)  $default,) {final _that = this;
switch (_that) {
case _EditorState():
return $default(_that.content,_that.openTabs,_that.currentTabPath,_that.targetLine);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  List<String> openTabs,  String? currentTabPath,  int? targetLine)?  $default,) {final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that.content,_that.openTabs,_that.currentTabPath,_that.targetLine);case _:
  return null;

}
}

}

/// @nodoc


class _EditorState implements EditorState {
  const _EditorState({this.content = '', final  List<String> openTabs = const [], this.currentTabPath, this.targetLine}): _openTabs = openTabs;
  

@override@JsonKey() final  String content;
 final  List<String> _openTabs;
@override@JsonKey() List<String> get openTabs {
  if (_openTabs is EqualUnmodifiableListView) return _openTabs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_openTabs);
}

@override final  String? currentTabPath;
@override final  int? targetLine;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorStateCopyWith<_EditorState> get copyWith => __$EditorStateCopyWithImpl<_EditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorState&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._openTabs, _openTabs)&&(identical(other.currentTabPath, currentTabPath) || other.currentTabPath == currentTabPath)&&(identical(other.targetLine, targetLine) || other.targetLine == targetLine));
}


@override
int get hashCode => Object.hash(runtimeType,content,const DeepCollectionEquality().hash(_openTabs),currentTabPath,targetLine);

@override
String toString() {
  return 'EditorState(content: $content, openTabs: $openTabs, currentTabPath: $currentTabPath, targetLine: $targetLine)';
}


}

/// @nodoc
abstract mixin class _$EditorStateCopyWith<$Res> implements $EditorStateCopyWith<$Res> {
  factory _$EditorStateCopyWith(_EditorState value, $Res Function(_EditorState) _then) = __$EditorStateCopyWithImpl;
@override @useResult
$Res call({
 String content, List<String> openTabs, String? currentTabPath, int? targetLine
});




}
/// @nodoc
class __$EditorStateCopyWithImpl<$Res>
    implements _$EditorStateCopyWith<$Res> {
  __$EditorStateCopyWithImpl(this._self, this._then);

  final _EditorState _self;
  final $Res Function(_EditorState) _then;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? openTabs = null,Object? currentTabPath = freezed,Object? targetLine = freezed,}) {
  return _then(_EditorState(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,openTabs: null == openTabs ? _self._openTabs : openTabs // ignore: cast_nullable_to_non_nullable
as List<String>,currentTabPath: freezed == currentTabPath ? _self.currentTabPath : currentTabPath // ignore: cast_nullable_to_non_nullable
as String?,targetLine: freezed == targetLine ? _self.targetLine : targetLine // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
