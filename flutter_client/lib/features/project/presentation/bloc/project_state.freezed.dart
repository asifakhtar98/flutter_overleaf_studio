// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectFolder {

 String get name; String get path; List<ProjectFolder> get children; bool get isExpanded;
/// Create a copy of ProjectFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectFolderCopyWith<ProjectFolder> get copyWith => _$ProjectFolderCopyWithImpl<ProjectFolder>(this as ProjectFolder, _$identity);

  /// Serializes this ProjectFolder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectFolder&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other.children, children)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path,const DeepCollectionEquality().hash(children),isExpanded);

@override
String toString() {
  return 'ProjectFolder(name: $name, path: $path, children: $children, isExpanded: $isExpanded)';
}


}

/// @nodoc
abstract mixin class $ProjectFolderCopyWith<$Res>  {
  factory $ProjectFolderCopyWith(ProjectFolder value, $Res Function(ProjectFolder) _then) = _$ProjectFolderCopyWithImpl;
@useResult
$Res call({
 String name, String path, List<ProjectFolder> children, bool isExpanded
});




}
/// @nodoc
class _$ProjectFolderCopyWithImpl<$Res>
    implements $ProjectFolderCopyWith<$Res> {
  _$ProjectFolderCopyWithImpl(this._self, this._then);

  final ProjectFolder _self;
  final $Res Function(ProjectFolder) _then;

/// Create a copy of ProjectFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = null,Object? children = null,Object? isExpanded = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ProjectFolder>,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectFolder].
extension ProjectFolderPatterns on ProjectFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectFolder value)  $default,){
final _that = this;
switch (_that) {
case _ProjectFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectFolder value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String path,  List<ProjectFolder> children,  bool isExpanded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectFolder() when $default != null:
return $default(_that.name,_that.path,_that.children,_that.isExpanded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String path,  List<ProjectFolder> children,  bool isExpanded)  $default,) {final _that = this;
switch (_that) {
case _ProjectFolder():
return $default(_that.name,_that.path,_that.children,_that.isExpanded);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String path,  List<ProjectFolder> children,  bool isExpanded)?  $default,) {final _that = this;
switch (_that) {
case _ProjectFolder() when $default != null:
return $default(_that.name,_that.path,_that.children,_that.isExpanded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectFolder implements ProjectFolder {
  const _ProjectFolder({required this.name, required this.path, final  List<ProjectFolder> children = const [], this.isExpanded = true}): _children = children;
  factory _ProjectFolder.fromJson(Map<String, dynamic> json) => _$ProjectFolderFromJson(json);

@override final  String name;
@override final  String path;
 final  List<ProjectFolder> _children;
@override@JsonKey() List<ProjectFolder> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@override@JsonKey() final  bool isExpanded;

/// Create a copy of ProjectFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectFolderCopyWith<_ProjectFolder> get copyWith => __$ProjectFolderCopyWithImpl<_ProjectFolder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectFolderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectFolder&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other._children, _children)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path,const DeepCollectionEquality().hash(_children),isExpanded);

@override
String toString() {
  return 'ProjectFolder(name: $name, path: $path, children: $children, isExpanded: $isExpanded)';
}


}

/// @nodoc
abstract mixin class _$ProjectFolderCopyWith<$Res> implements $ProjectFolderCopyWith<$Res> {
  factory _$ProjectFolderCopyWith(_ProjectFolder value, $Res Function(_ProjectFolder) _then) = __$ProjectFolderCopyWithImpl;
@override @useResult
$Res call({
 String name, String path, List<ProjectFolder> children, bool isExpanded
});




}
/// @nodoc
class __$ProjectFolderCopyWithImpl<$Res>
    implements _$ProjectFolderCopyWith<$Res> {
  __$ProjectFolderCopyWithImpl(this._self, this._then);

  final _ProjectFolder _self;
  final $Res Function(_ProjectFolder) _then;

/// Create a copy of ProjectFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? children = null,Object? isExpanded = null,}) {
  return _then(_ProjectFolder(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ProjectFolder>,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProjectState {

 List<ProjectFile> get files; List<ProjectFolder> get folders; String? get activeFilePath; String? get mainFilePath;
/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectStateCopyWith<ProjectState> get copyWith => _$ProjectStateCopyWithImpl<ProjectState>(this as ProjectState, _$identity);

  /// Serializes this ProjectState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectState&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.folders, folders)&&(identical(other.activeFilePath, activeFilePath) || other.activeFilePath == activeFilePath)&&(identical(other.mainFilePath, mainFilePath) || other.mainFilePath == mainFilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(folders),activeFilePath,mainFilePath);

@override
String toString() {
  return 'ProjectState(files: $files, folders: $folders, activeFilePath: $activeFilePath, mainFilePath: $mainFilePath)';
}


}

/// @nodoc
abstract mixin class $ProjectStateCopyWith<$Res>  {
  factory $ProjectStateCopyWith(ProjectState value, $Res Function(ProjectState) _then) = _$ProjectStateCopyWithImpl;
@useResult
$Res call({
 List<ProjectFile> files, List<ProjectFolder> folders, String? activeFilePath, String? mainFilePath
});




}
/// @nodoc
class _$ProjectStateCopyWithImpl<$Res>
    implements $ProjectStateCopyWith<$Res> {
  _$ProjectStateCopyWithImpl(this._self, this._then);

  final ProjectState _self;
  final $Res Function(ProjectState) _then;

/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,Object? folders = null,Object? activeFilePath = freezed,Object? mainFilePath = freezed,}) {
  return _then(_self.copyWith(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<ProjectFile>,folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<ProjectFolder>,activeFilePath: freezed == activeFilePath ? _self.activeFilePath : activeFilePath // ignore: cast_nullable_to_non_nullable
as String?,mainFilePath: freezed == mainFilePath ? _self.mainFilePath : mainFilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectState].
extension ProjectStatePatterns on ProjectState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectState value)  $default,){
final _that = this;
switch (_that) {
case _ProjectState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectState value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProjectFile> files,  List<ProjectFolder> folders,  String? activeFilePath,  String? mainFilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
return $default(_that.files,_that.folders,_that.activeFilePath,_that.mainFilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProjectFile> files,  List<ProjectFolder> folders,  String? activeFilePath,  String? mainFilePath)  $default,) {final _that = this;
switch (_that) {
case _ProjectState():
return $default(_that.files,_that.folders,_that.activeFilePath,_that.mainFilePath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProjectFile> files,  List<ProjectFolder> folders,  String? activeFilePath,  String? mainFilePath)?  $default,) {final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
return $default(_that.files,_that.folders,_that.activeFilePath,_that.mainFilePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectState implements ProjectState {
  const _ProjectState({final  List<ProjectFile> files = const [], final  List<ProjectFolder> folders = const [], this.activeFilePath, this.mainFilePath}): _files = files,_folders = folders;
  factory _ProjectState.fromJson(Map<String, dynamic> json) => _$ProjectStateFromJson(json);

 final  List<ProjectFile> _files;
@override@JsonKey() List<ProjectFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

 final  List<ProjectFolder> _folders;
@override@JsonKey() List<ProjectFolder> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}

@override final  String? activeFilePath;
@override final  String? mainFilePath;

/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectStateCopyWith<_ProjectState> get copyWith => __$ProjectStateCopyWithImpl<_ProjectState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectState&&const DeepCollectionEquality().equals(other._files, _files)&&const DeepCollectionEquality().equals(other._folders, _folders)&&(identical(other.activeFilePath, activeFilePath) || other.activeFilePath == activeFilePath)&&(identical(other.mainFilePath, mainFilePath) || other.mainFilePath == mainFilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files),const DeepCollectionEquality().hash(_folders),activeFilePath,mainFilePath);

@override
String toString() {
  return 'ProjectState(files: $files, folders: $folders, activeFilePath: $activeFilePath, mainFilePath: $mainFilePath)';
}


}

/// @nodoc
abstract mixin class _$ProjectStateCopyWith<$Res> implements $ProjectStateCopyWith<$Res> {
  factory _$ProjectStateCopyWith(_ProjectState value, $Res Function(_ProjectState) _then) = __$ProjectStateCopyWithImpl;
@override @useResult
$Res call({
 List<ProjectFile> files, List<ProjectFolder> folders, String? activeFilePath, String? mainFilePath
});




}
/// @nodoc
class __$ProjectStateCopyWithImpl<$Res>
    implements _$ProjectStateCopyWith<$Res> {
  __$ProjectStateCopyWithImpl(this._self, this._then);

  final _ProjectState _self;
  final $Res Function(_ProjectState) _then;

/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,Object? folders = null,Object? activeFilePath = freezed,Object? mainFilePath = freezed,}) {
  return _then(_ProjectState(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<ProjectFile>,folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<ProjectFolder>,activeFilePath: freezed == activeFilePath ? _self.activeFilePath : activeFilePath // ignore: cast_nullable_to_non_nullable
as String?,mainFilePath: freezed == mainFilePath ? _self.mainFilePath : mainFilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
