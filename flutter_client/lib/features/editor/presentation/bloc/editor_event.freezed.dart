// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorEvent {

 String get content;
/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorEventCopyWith<EditorEvent> get copyWith => _$EditorEventCopyWithImpl<EditorEvent>(this as EditorEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorEvent&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'EditorEvent(content: $content)';
}


}

/// @nodoc
abstract mixin class $EditorEventCopyWith<$Res>  {
  factory $EditorEventCopyWith(EditorEvent value, $Res Function(EditorEvent) _then) = _$EditorEventCopyWithImpl;
@useResult
$Res call({
 String content
});




}
/// @nodoc
class _$EditorEventCopyWithImpl<$Res>
    implements $EditorEventCopyWith<$Res> {
  _$EditorEventCopyWithImpl(this._self, this._then);

  final EditorEvent _self;
  final $Res Function(EditorEvent) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EditorEvent].
extension EditorEventPatterns on EditorEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FileOpened value)?  fileOpened,TResult Function( ContentChanged value)?  contentChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that);case ContentChanged() when contentChanged != null:
return contentChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FileOpened value)  fileOpened,required TResult Function( ContentChanged value)  contentChanged,}){
final _that = this;
switch (_that) {
case FileOpened():
return fileOpened(_that);case ContentChanged():
return contentChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FileOpened value)?  fileOpened,TResult? Function( ContentChanged value)?  contentChanged,}){
final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that);case ContentChanged() when contentChanged != null:
return contentChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String path,  String content)?  fileOpened,TResult Function( String content)?  contentChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that.path,_that.content);case ContentChanged() when contentChanged != null:
return contentChanged(_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String path,  String content)  fileOpened,required TResult Function( String content)  contentChanged,}) {final _that = this;
switch (_that) {
case FileOpened():
return fileOpened(_that.path,_that.content);case ContentChanged():
return contentChanged(_that.content);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String path,  String content)?  fileOpened,TResult? Function( String content)?  contentChanged,}) {final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that.path,_that.content);case ContentChanged() when contentChanged != null:
return contentChanged(_that.content);case _:
  return null;

}
}

}

/// @nodoc


class FileOpened implements EditorEvent {
  const FileOpened({required this.path, required this.content});
  

 final  String path;
@override final  String content;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileOpenedCopyWith<FileOpened> get copyWith => _$FileOpenedCopyWithImpl<FileOpened>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileOpened&&(identical(other.path, path) || other.path == path)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,path,content);

@override
String toString() {
  return 'EditorEvent.fileOpened(path: $path, content: $content)';
}


}

/// @nodoc
abstract mixin class $FileOpenedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $FileOpenedCopyWith(FileOpened value, $Res Function(FileOpened) _then) = _$FileOpenedCopyWithImpl;
@override @useResult
$Res call({
 String path, String content
});




}
/// @nodoc
class _$FileOpenedCopyWithImpl<$Res>
    implements $FileOpenedCopyWith<$Res> {
  _$FileOpenedCopyWithImpl(this._self, this._then);

  final FileOpened _self;
  final $Res Function(FileOpened) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? content = null,}) {
  return _then(FileOpened(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ContentChanged implements EditorEvent {
  const ContentChanged({required this.content});
  

@override final  String content;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentChangedCopyWith<ContentChanged> get copyWith => _$ContentChangedCopyWithImpl<ContentChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentChanged&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'EditorEvent.contentChanged(content: $content)';
}


}

/// @nodoc
abstract mixin class $ContentChangedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $ContentChangedCopyWith(ContentChanged value, $Res Function(ContentChanged) _then) = _$ContentChangedCopyWithImpl;
@override @useResult
$Res call({
 String content
});




}
/// @nodoc
class _$ContentChangedCopyWithImpl<$Res>
    implements $ContentChangedCopyWith<$Res> {
  _$ContentChangedCopyWithImpl(this._self, this._then);

  final ContentChanged _self;
  final $Res Function(ContentChanged) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(ContentChanged(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
