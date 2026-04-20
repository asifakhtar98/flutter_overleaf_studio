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





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent()';
}


}

/// @nodoc
class $EditorEventCopyWith<$Res>  {
$EditorEventCopyWith(EditorEvent _, $Res Function(EditorEvent) __);
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FileOpened value)?  fileOpened,TResult Function( ContentChanged value)?  contentChanged,TResult Function( TabOpened value)?  tabOpened,TResult Function( TabClosed value)?  tabClosed,TResult Function( TabSwitched value)?  tabSwitched,TResult Function( FileSaved value)?  fileSaved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that);case ContentChanged() when contentChanged != null:
return contentChanged(_that);case TabOpened() when tabOpened != null:
return tabOpened(_that);case TabClosed() when tabClosed != null:
return tabClosed(_that);case TabSwitched() when tabSwitched != null:
return tabSwitched(_that);case FileSaved() when fileSaved != null:
return fileSaved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FileOpened value)  fileOpened,required TResult Function( ContentChanged value)  contentChanged,required TResult Function( TabOpened value)  tabOpened,required TResult Function( TabClosed value)  tabClosed,required TResult Function( TabSwitched value)  tabSwitched,required TResult Function( FileSaved value)  fileSaved,}){
final _that = this;
switch (_that) {
case FileOpened():
return fileOpened(_that);case ContentChanged():
return contentChanged(_that);case TabOpened():
return tabOpened(_that);case TabClosed():
return tabClosed(_that);case TabSwitched():
return tabSwitched(_that);case FileSaved():
return fileSaved(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FileOpened value)?  fileOpened,TResult? Function( ContentChanged value)?  contentChanged,TResult? Function( TabOpened value)?  tabOpened,TResult? Function( TabClosed value)?  tabClosed,TResult? Function( TabSwitched value)?  tabSwitched,TResult? Function( FileSaved value)?  fileSaved,}){
final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that);case ContentChanged() when contentChanged != null:
return contentChanged(_that);case TabOpened() when tabOpened != null:
return tabOpened(_that);case TabClosed() when tabClosed != null:
return tabClosed(_that);case TabSwitched() when tabSwitched != null:
return tabSwitched(_that);case FileSaved() when fileSaved != null:
return fileSaved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String path,  String content)?  fileOpened,TResult Function( String content)?  contentChanged,TResult Function( String path,  String content)?  tabOpened,TResult Function( String path)?  tabClosed,TResult Function( String path)?  tabSwitched,TResult Function()?  fileSaved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that.path,_that.content);case ContentChanged() when contentChanged != null:
return contentChanged(_that.content);case TabOpened() when tabOpened != null:
return tabOpened(_that.path,_that.content);case TabClosed() when tabClosed != null:
return tabClosed(_that.path);case TabSwitched() when tabSwitched != null:
return tabSwitched(_that.path);case FileSaved() when fileSaved != null:
return fileSaved();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String path,  String content)  fileOpened,required TResult Function( String content)  contentChanged,required TResult Function( String path,  String content)  tabOpened,required TResult Function( String path)  tabClosed,required TResult Function( String path)  tabSwitched,required TResult Function()  fileSaved,}) {final _that = this;
switch (_that) {
case FileOpened():
return fileOpened(_that.path,_that.content);case ContentChanged():
return contentChanged(_that.content);case TabOpened():
return tabOpened(_that.path,_that.content);case TabClosed():
return tabClosed(_that.path);case TabSwitched():
return tabSwitched(_that.path);case FileSaved():
return fileSaved();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String path,  String content)?  fileOpened,TResult? Function( String content)?  contentChanged,TResult? Function( String path,  String content)?  tabOpened,TResult? Function( String path)?  tabClosed,TResult? Function( String path)?  tabSwitched,TResult? Function()?  fileSaved,}) {final _that = this;
switch (_that) {
case FileOpened() when fileOpened != null:
return fileOpened(_that.path,_that.content);case ContentChanged() when contentChanged != null:
return contentChanged(_that.content);case TabOpened() when tabOpened != null:
return tabOpened(_that.path,_that.content);case TabClosed() when tabClosed != null:
return tabClosed(_that.path);case TabSwitched() when tabSwitched != null:
return tabSwitched(_that.path);case FileSaved() when fileSaved != null:
return fileSaved();case _:
  return null;

}
}

}

/// @nodoc


class FileOpened implements EditorEvent {
  const FileOpened({required this.path, required this.content});
  

 final  String path;
 final  String content;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
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
@useResult
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
@pragma('vm:prefer-inline') $Res call({Object? path = null,Object? content = null,}) {
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
  

 final  String content;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
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
@useResult
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
@pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(ContentChanged(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TabOpened implements EditorEvent {
  const TabOpened({required this.path, required this.content});
  

 final  String path;
 final  String content;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TabOpenedCopyWith<TabOpened> get copyWith => _$TabOpenedCopyWithImpl<TabOpened>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TabOpened&&(identical(other.path, path) || other.path == path)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,path,content);

@override
String toString() {
  return 'EditorEvent.tabOpened(path: $path, content: $content)';
}


}

/// @nodoc
abstract mixin class $TabOpenedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $TabOpenedCopyWith(TabOpened value, $Res Function(TabOpened) _then) = _$TabOpenedCopyWithImpl;
@useResult
$Res call({
 String path, String content
});




}
/// @nodoc
class _$TabOpenedCopyWithImpl<$Res>
    implements $TabOpenedCopyWith<$Res> {
  _$TabOpenedCopyWithImpl(this._self, this._then);

  final TabOpened _self;
  final $Res Function(TabOpened) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,Object? content = null,}) {
  return _then(TabOpened(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TabClosed implements EditorEvent {
  const TabClosed({required this.path});
  

 final  String path;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TabClosedCopyWith<TabClosed> get copyWith => _$TabClosedCopyWithImpl<TabClosed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TabClosed&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'EditorEvent.tabClosed(path: $path)';
}


}

/// @nodoc
abstract mixin class $TabClosedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $TabClosedCopyWith(TabClosed value, $Res Function(TabClosed) _then) = _$TabClosedCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$TabClosedCopyWithImpl<$Res>
    implements $TabClosedCopyWith<$Res> {
  _$TabClosedCopyWithImpl(this._self, this._then);

  final TabClosed _self;
  final $Res Function(TabClosed) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(TabClosed(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TabSwitched implements EditorEvent {
  const TabSwitched({required this.path});
  

 final  String path;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TabSwitchedCopyWith<TabSwitched> get copyWith => _$TabSwitchedCopyWithImpl<TabSwitched>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TabSwitched&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'EditorEvent.tabSwitched(path: $path)';
}


}

/// @nodoc
abstract mixin class $TabSwitchedCopyWith<$Res> implements $EditorEventCopyWith<$Res> {
  factory $TabSwitchedCopyWith(TabSwitched value, $Res Function(TabSwitched) _then) = _$TabSwitchedCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$TabSwitchedCopyWithImpl<$Res>
    implements $TabSwitchedCopyWith<$Res> {
  _$TabSwitchedCopyWithImpl(this._self, this._then);

  final TabSwitched _self;
  final $Res Function(TabSwitched) _then;

/// Create a copy of EditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(TabSwitched(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FileSaved implements EditorEvent {
  const FileSaved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileSaved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditorEvent.fileSaved()';
}


}




// dart format on
