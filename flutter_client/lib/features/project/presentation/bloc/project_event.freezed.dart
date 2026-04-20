// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectEvent()';
}


}

/// @nodoc
class $ProjectEventCopyWith<$Res>  {
$ProjectEventCopyWith(ProjectEvent _, $Res Function(ProjectEvent) __);
}


/// Adds pattern-matching-related methods to [ProjectEvent].
extension ProjectEventPatterns on ProjectEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddFile value)?  addFile,TResult Function( RemoveFile value)?  removeFile,TResult Function( RenameFile value)?  renameFile,TResult Function( SelectFile value)?  selectFile,TResult Function( UpdateFileContent value)?  updateFileContent,TResult Function( SetMainFile value)?  setMainFile,TResult Function( AddFolder value)?  addFolder,TResult Function( RenameFolder value)?  renameFolder,TResult Function( DeleteFolder value)?  deleteFolder,TResult Function( ToggleFolder value)?  toggleFolder,TResult Function( ImportProjectEvent value)?  importProject,TResult Function( ExportProjectEvent value)?  exportProject,TResult Function( LoadFiles value)?  loadFiles,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddFile() when addFile != null:
return addFile(_that);case RemoveFile() when removeFile != null:
return removeFile(_that);case RenameFile() when renameFile != null:
return renameFile(_that);case SelectFile() when selectFile != null:
return selectFile(_that);case UpdateFileContent() when updateFileContent != null:
return updateFileContent(_that);case SetMainFile() when setMainFile != null:
return setMainFile(_that);case AddFolder() when addFolder != null:
return addFolder(_that);case RenameFolder() when renameFolder != null:
return renameFolder(_that);case DeleteFolder() when deleteFolder != null:
return deleteFolder(_that);case ToggleFolder() when toggleFolder != null:
return toggleFolder(_that);case ImportProjectEvent() when importProject != null:
return importProject(_that);case ExportProjectEvent() when exportProject != null:
return exportProject(_that);case LoadFiles() when loadFiles != null:
return loadFiles(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddFile value)  addFile,required TResult Function( RemoveFile value)  removeFile,required TResult Function( RenameFile value)  renameFile,required TResult Function( SelectFile value)  selectFile,required TResult Function( UpdateFileContent value)  updateFileContent,required TResult Function( SetMainFile value)  setMainFile,required TResult Function( AddFolder value)  addFolder,required TResult Function( RenameFolder value)  renameFolder,required TResult Function( DeleteFolder value)  deleteFolder,required TResult Function( ToggleFolder value)  toggleFolder,required TResult Function( ImportProjectEvent value)  importProject,required TResult Function( ExportProjectEvent value)  exportProject,required TResult Function( LoadFiles value)  loadFiles,}){
final _that = this;
switch (_that) {
case AddFile():
return addFile(_that);case RemoveFile():
return removeFile(_that);case RenameFile():
return renameFile(_that);case SelectFile():
return selectFile(_that);case UpdateFileContent():
return updateFileContent(_that);case SetMainFile():
return setMainFile(_that);case AddFolder():
return addFolder(_that);case RenameFolder():
return renameFolder(_that);case DeleteFolder():
return deleteFolder(_that);case ToggleFolder():
return toggleFolder(_that);case ImportProjectEvent():
return importProject(_that);case ExportProjectEvent():
return exportProject(_that);case LoadFiles():
return loadFiles(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddFile value)?  addFile,TResult? Function( RemoveFile value)?  removeFile,TResult? Function( RenameFile value)?  renameFile,TResult? Function( SelectFile value)?  selectFile,TResult? Function( UpdateFileContent value)?  updateFileContent,TResult? Function( SetMainFile value)?  setMainFile,TResult? Function( AddFolder value)?  addFolder,TResult? Function( RenameFolder value)?  renameFolder,TResult? Function( DeleteFolder value)?  deleteFolder,TResult? Function( ToggleFolder value)?  toggleFolder,TResult? Function( ImportProjectEvent value)?  importProject,TResult? Function( ExportProjectEvent value)?  exportProject,TResult? Function( LoadFiles value)?  loadFiles,}){
final _that = this;
switch (_that) {
case AddFile() when addFile != null:
return addFile(_that);case RemoveFile() when removeFile != null:
return removeFile(_that);case RenameFile() when renameFile != null:
return renameFile(_that);case SelectFile() when selectFile != null:
return selectFile(_that);case UpdateFileContent() when updateFileContent != null:
return updateFileContent(_that);case SetMainFile() when setMainFile != null:
return setMainFile(_that);case AddFolder() when addFolder != null:
return addFolder(_that);case RenameFolder() when renameFolder != null:
return renameFolder(_that);case DeleteFolder() when deleteFolder != null:
return deleteFolder(_that);case ToggleFolder() when toggleFolder != null:
return toggleFolder(_that);case ImportProjectEvent() when importProject != null:
return importProject(_that);case ExportProjectEvent() when exportProject != null:
return exportProject(_that);case LoadFiles() when loadFiles != null:
return loadFiles(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String name,  String path,  String content)?  addFile,TResult Function( String path)?  removeFile,TResult Function( String oldPath,  String newName)?  renameFile,TResult Function( String path)?  selectFile,TResult Function( String path,  String content)?  updateFileContent,TResult Function( String path)?  setMainFile,TResult Function( String name,  String path)?  addFolder,TResult Function( String oldPath,  String newName)?  renameFolder,TResult Function( String path)?  deleteFolder,TResult Function( String path)?  toggleFolder,TResult Function( List<int>? bytes)?  importProject,TResult Function()?  exportProject,TResult Function( List<ProjectFile> files,  String? activeFilePath,  String? mainFilePath)?  loadFiles,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddFile() when addFile != null:
return addFile(_that.name,_that.path,_that.content);case RemoveFile() when removeFile != null:
return removeFile(_that.path);case RenameFile() when renameFile != null:
return renameFile(_that.oldPath,_that.newName);case SelectFile() when selectFile != null:
return selectFile(_that.path);case UpdateFileContent() when updateFileContent != null:
return updateFileContent(_that.path,_that.content);case SetMainFile() when setMainFile != null:
return setMainFile(_that.path);case AddFolder() when addFolder != null:
return addFolder(_that.name,_that.path);case RenameFolder() when renameFolder != null:
return renameFolder(_that.oldPath,_that.newName);case DeleteFolder() when deleteFolder != null:
return deleteFolder(_that.path);case ToggleFolder() when toggleFolder != null:
return toggleFolder(_that.path);case ImportProjectEvent() when importProject != null:
return importProject(_that.bytes);case ExportProjectEvent() when exportProject != null:
return exportProject();case LoadFiles() when loadFiles != null:
return loadFiles(_that.files,_that.activeFilePath,_that.mainFilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String name,  String path,  String content)  addFile,required TResult Function( String path)  removeFile,required TResult Function( String oldPath,  String newName)  renameFile,required TResult Function( String path)  selectFile,required TResult Function( String path,  String content)  updateFileContent,required TResult Function( String path)  setMainFile,required TResult Function( String name,  String path)  addFolder,required TResult Function( String oldPath,  String newName)  renameFolder,required TResult Function( String path)  deleteFolder,required TResult Function( String path)  toggleFolder,required TResult Function( List<int>? bytes)  importProject,required TResult Function()  exportProject,required TResult Function( List<ProjectFile> files,  String? activeFilePath,  String? mainFilePath)  loadFiles,}) {final _that = this;
switch (_that) {
case AddFile():
return addFile(_that.name,_that.path,_that.content);case RemoveFile():
return removeFile(_that.path);case RenameFile():
return renameFile(_that.oldPath,_that.newName);case SelectFile():
return selectFile(_that.path);case UpdateFileContent():
return updateFileContent(_that.path,_that.content);case SetMainFile():
return setMainFile(_that.path);case AddFolder():
return addFolder(_that.name,_that.path);case RenameFolder():
return renameFolder(_that.oldPath,_that.newName);case DeleteFolder():
return deleteFolder(_that.path);case ToggleFolder():
return toggleFolder(_that.path);case ImportProjectEvent():
return importProject(_that.bytes);case ExportProjectEvent():
return exportProject();case LoadFiles():
return loadFiles(_that.files,_that.activeFilePath,_that.mainFilePath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String name,  String path,  String content)?  addFile,TResult? Function( String path)?  removeFile,TResult? Function( String oldPath,  String newName)?  renameFile,TResult? Function( String path)?  selectFile,TResult? Function( String path,  String content)?  updateFileContent,TResult? Function( String path)?  setMainFile,TResult? Function( String name,  String path)?  addFolder,TResult? Function( String oldPath,  String newName)?  renameFolder,TResult? Function( String path)?  deleteFolder,TResult? Function( String path)?  toggleFolder,TResult? Function( List<int>? bytes)?  importProject,TResult? Function()?  exportProject,TResult? Function( List<ProjectFile> files,  String? activeFilePath,  String? mainFilePath)?  loadFiles,}) {final _that = this;
switch (_that) {
case AddFile() when addFile != null:
return addFile(_that.name,_that.path,_that.content);case RemoveFile() when removeFile != null:
return removeFile(_that.path);case RenameFile() when renameFile != null:
return renameFile(_that.oldPath,_that.newName);case SelectFile() when selectFile != null:
return selectFile(_that.path);case UpdateFileContent() when updateFileContent != null:
return updateFileContent(_that.path,_that.content);case SetMainFile() when setMainFile != null:
return setMainFile(_that.path);case AddFolder() when addFolder != null:
return addFolder(_that.name,_that.path);case RenameFolder() when renameFolder != null:
return renameFolder(_that.oldPath,_that.newName);case DeleteFolder() when deleteFolder != null:
return deleteFolder(_that.path);case ToggleFolder() when toggleFolder != null:
return toggleFolder(_that.path);case ImportProjectEvent() when importProject != null:
return importProject(_that.bytes);case ExportProjectEvent() when exportProject != null:
return exportProject();case LoadFiles() when loadFiles != null:
return loadFiles(_that.files,_that.activeFilePath,_that.mainFilePath);case _:
  return null;

}
}

}

/// @nodoc


class AddFile implements ProjectEvent {
  const AddFile({required this.name, required this.path, this.content = ''});
  

 final  String name;
 final  String path;
@JsonKey() final  String content;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddFileCopyWith<AddFile> get copyWith => _$AddFileCopyWithImpl<AddFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddFile&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,name,path,content);

@override
String toString() {
  return 'ProjectEvent.addFile(name: $name, path: $path, content: $content)';
}


}

/// @nodoc
abstract mixin class $AddFileCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $AddFileCopyWith(AddFile value, $Res Function(AddFile) _then) = _$AddFileCopyWithImpl;
@useResult
$Res call({
 String name, String path, String content
});




}
/// @nodoc
class _$AddFileCopyWithImpl<$Res>
    implements $AddFileCopyWith<$Res> {
  _$AddFileCopyWithImpl(this._self, this._then);

  final AddFile _self;
  final $Res Function(AddFile) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? content = null,}) {
  return _then(AddFile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RemoveFile implements ProjectEvent {
  const RemoveFile({required this.path});
  

 final  String path;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveFileCopyWith<RemoveFile> get copyWith => _$RemoveFileCopyWithImpl<RemoveFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveFile&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'ProjectEvent.removeFile(path: $path)';
}


}

/// @nodoc
abstract mixin class $RemoveFileCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $RemoveFileCopyWith(RemoveFile value, $Res Function(RemoveFile) _then) = _$RemoveFileCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$RemoveFileCopyWithImpl<$Res>
    implements $RemoveFileCopyWith<$Res> {
  _$RemoveFileCopyWithImpl(this._self, this._then);

  final RemoveFile _self;
  final $Res Function(RemoveFile) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(RemoveFile(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RenameFile implements ProjectEvent {
  const RenameFile({required this.oldPath, required this.newName});
  

 final  String oldPath;
 final  String newName;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenameFileCopyWith<RenameFile> get copyWith => _$RenameFileCopyWithImpl<RenameFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenameFile&&(identical(other.oldPath, oldPath) || other.oldPath == oldPath)&&(identical(other.newName, newName) || other.newName == newName));
}


@override
int get hashCode => Object.hash(runtimeType,oldPath,newName);

@override
String toString() {
  return 'ProjectEvent.renameFile(oldPath: $oldPath, newName: $newName)';
}


}

/// @nodoc
abstract mixin class $RenameFileCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $RenameFileCopyWith(RenameFile value, $Res Function(RenameFile) _then) = _$RenameFileCopyWithImpl;
@useResult
$Res call({
 String oldPath, String newName
});




}
/// @nodoc
class _$RenameFileCopyWithImpl<$Res>
    implements $RenameFileCopyWith<$Res> {
  _$RenameFileCopyWithImpl(this._self, this._then);

  final RenameFile _self;
  final $Res Function(RenameFile) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? oldPath = null,Object? newName = null,}) {
  return _then(RenameFile(
oldPath: null == oldPath ? _self.oldPath : oldPath // ignore: cast_nullable_to_non_nullable
as String,newName: null == newName ? _self.newName : newName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SelectFile implements ProjectEvent {
  const SelectFile({required this.path});
  

 final  String path;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectFileCopyWith<SelectFile> get copyWith => _$SelectFileCopyWithImpl<SelectFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectFile&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'ProjectEvent.selectFile(path: $path)';
}


}

/// @nodoc
abstract mixin class $SelectFileCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $SelectFileCopyWith(SelectFile value, $Res Function(SelectFile) _then) = _$SelectFileCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$SelectFileCopyWithImpl<$Res>
    implements $SelectFileCopyWith<$Res> {
  _$SelectFileCopyWithImpl(this._self, this._then);

  final SelectFile _self;
  final $Res Function(SelectFile) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(SelectFile(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateFileContent implements ProjectEvent {
  const UpdateFileContent({required this.path, required this.content});
  

 final  String path;
 final  String content;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateFileContentCopyWith<UpdateFileContent> get copyWith => _$UpdateFileContentCopyWithImpl<UpdateFileContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateFileContent&&(identical(other.path, path) || other.path == path)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,path,content);

@override
String toString() {
  return 'ProjectEvent.updateFileContent(path: $path, content: $content)';
}


}

/// @nodoc
abstract mixin class $UpdateFileContentCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $UpdateFileContentCopyWith(UpdateFileContent value, $Res Function(UpdateFileContent) _then) = _$UpdateFileContentCopyWithImpl;
@useResult
$Res call({
 String path, String content
});




}
/// @nodoc
class _$UpdateFileContentCopyWithImpl<$Res>
    implements $UpdateFileContentCopyWith<$Res> {
  _$UpdateFileContentCopyWithImpl(this._self, this._then);

  final UpdateFileContent _self;
  final $Res Function(UpdateFileContent) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,Object? content = null,}) {
  return _then(UpdateFileContent(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SetMainFile implements ProjectEvent {
  const SetMainFile({required this.path});
  

 final  String path;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetMainFileCopyWith<SetMainFile> get copyWith => _$SetMainFileCopyWithImpl<SetMainFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetMainFile&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'ProjectEvent.setMainFile(path: $path)';
}


}

/// @nodoc
abstract mixin class $SetMainFileCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $SetMainFileCopyWith(SetMainFile value, $Res Function(SetMainFile) _then) = _$SetMainFileCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$SetMainFileCopyWithImpl<$Res>
    implements $SetMainFileCopyWith<$Res> {
  _$SetMainFileCopyWithImpl(this._self, this._then);

  final SetMainFile _self;
  final $Res Function(SetMainFile) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(SetMainFile(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AddFolder implements ProjectEvent {
  const AddFolder({required this.name, required this.path});
  

 final  String name;
 final  String path;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddFolderCopyWith<AddFolder> get copyWith => _$AddFolderCopyWithImpl<AddFolder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddFolder&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,name,path);

@override
String toString() {
  return 'ProjectEvent.addFolder(name: $name, path: $path)';
}


}

/// @nodoc
abstract mixin class $AddFolderCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $AddFolderCopyWith(AddFolder value, $Res Function(AddFolder) _then) = _$AddFolderCopyWithImpl;
@useResult
$Res call({
 String name, String path
});




}
/// @nodoc
class _$AddFolderCopyWithImpl<$Res>
    implements $AddFolderCopyWith<$Res> {
  _$AddFolderCopyWithImpl(this._self, this._then);

  final AddFolder _self;
  final $Res Function(AddFolder) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,}) {
  return _then(AddFolder(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RenameFolder implements ProjectEvent {
  const RenameFolder({required this.oldPath, required this.newName});
  

 final  String oldPath;
 final  String newName;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenameFolderCopyWith<RenameFolder> get copyWith => _$RenameFolderCopyWithImpl<RenameFolder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenameFolder&&(identical(other.oldPath, oldPath) || other.oldPath == oldPath)&&(identical(other.newName, newName) || other.newName == newName));
}


@override
int get hashCode => Object.hash(runtimeType,oldPath,newName);

@override
String toString() {
  return 'ProjectEvent.renameFolder(oldPath: $oldPath, newName: $newName)';
}


}

/// @nodoc
abstract mixin class $RenameFolderCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $RenameFolderCopyWith(RenameFolder value, $Res Function(RenameFolder) _then) = _$RenameFolderCopyWithImpl;
@useResult
$Res call({
 String oldPath, String newName
});




}
/// @nodoc
class _$RenameFolderCopyWithImpl<$Res>
    implements $RenameFolderCopyWith<$Res> {
  _$RenameFolderCopyWithImpl(this._self, this._then);

  final RenameFolder _self;
  final $Res Function(RenameFolder) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? oldPath = null,Object? newName = null,}) {
  return _then(RenameFolder(
oldPath: null == oldPath ? _self.oldPath : oldPath // ignore: cast_nullable_to_non_nullable
as String,newName: null == newName ? _self.newName : newName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeleteFolder implements ProjectEvent {
  const DeleteFolder({required this.path});
  

 final  String path;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteFolderCopyWith<DeleteFolder> get copyWith => _$DeleteFolderCopyWithImpl<DeleteFolder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteFolder&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'ProjectEvent.deleteFolder(path: $path)';
}


}

/// @nodoc
abstract mixin class $DeleteFolderCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $DeleteFolderCopyWith(DeleteFolder value, $Res Function(DeleteFolder) _then) = _$DeleteFolderCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$DeleteFolderCopyWithImpl<$Res>
    implements $DeleteFolderCopyWith<$Res> {
  _$DeleteFolderCopyWithImpl(this._self, this._then);

  final DeleteFolder _self;
  final $Res Function(DeleteFolder) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(DeleteFolder(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ToggleFolder implements ProjectEvent {
  const ToggleFolder({required this.path});
  

 final  String path;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleFolderCopyWith<ToggleFolder> get copyWith => _$ToggleFolderCopyWithImpl<ToggleFolder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleFolder&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'ProjectEvent.toggleFolder(path: $path)';
}


}

/// @nodoc
abstract mixin class $ToggleFolderCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $ToggleFolderCopyWith(ToggleFolder value, $Res Function(ToggleFolder) _then) = _$ToggleFolderCopyWithImpl;
@useResult
$Res call({
 String path
});




}
/// @nodoc
class _$ToggleFolderCopyWithImpl<$Res>
    implements $ToggleFolderCopyWith<$Res> {
  _$ToggleFolderCopyWithImpl(this._self, this._then);

  final ToggleFolder _self;
  final $Res Function(ToggleFolder) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(ToggleFolder(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ImportProjectEvent implements ProjectEvent {
  const ImportProjectEvent({final  List<int>? bytes}): _bytes = bytes;
  

 final  List<int>? _bytes;
 List<int>? get bytes {
  final value = _bytes;
  if (value == null) return null;
  if (_bytes is EqualUnmodifiableListView) return _bytes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportProjectEventCopyWith<ImportProjectEvent> get copyWith => _$ImportProjectEventCopyWithImpl<ImportProjectEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportProjectEvent&&const DeepCollectionEquality().equals(other._bytes, _bytes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bytes));

@override
String toString() {
  return 'ProjectEvent.importProject(bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class $ImportProjectEventCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $ImportProjectEventCopyWith(ImportProjectEvent value, $Res Function(ImportProjectEvent) _then) = _$ImportProjectEventCopyWithImpl;
@useResult
$Res call({
 List<int>? bytes
});




}
/// @nodoc
class _$ImportProjectEventCopyWithImpl<$Res>
    implements $ImportProjectEventCopyWith<$Res> {
  _$ImportProjectEventCopyWithImpl(this._self, this._then);

  final ImportProjectEvent _self;
  final $Res Function(ImportProjectEvent) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bytes = freezed,}) {
  return _then(ImportProjectEvent(
bytes: freezed == bytes ? _self._bytes : bytes // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}


}

/// @nodoc


class ExportProjectEvent implements ProjectEvent {
  const ExportProjectEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportProjectEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectEvent.exportProject()';
}


}




/// @nodoc


class LoadFiles implements ProjectEvent {
  const LoadFiles({required final  List<ProjectFile> files, this.activeFilePath, this.mainFilePath}): _files = files;
  

 final  List<ProjectFile> _files;
 List<ProjectFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

 final  String? activeFilePath;
 final  String? mainFilePath;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadFilesCopyWith<LoadFiles> get copyWith => _$LoadFilesCopyWithImpl<LoadFiles>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadFiles&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.activeFilePath, activeFilePath) || other.activeFilePath == activeFilePath)&&(identical(other.mainFilePath, mainFilePath) || other.mainFilePath == mainFilePath));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files),activeFilePath,mainFilePath);

@override
String toString() {
  return 'ProjectEvent.loadFiles(files: $files, activeFilePath: $activeFilePath, mainFilePath: $mainFilePath)';
}


}

/// @nodoc
abstract mixin class $LoadFilesCopyWith<$Res> implements $ProjectEventCopyWith<$Res> {
  factory $LoadFilesCopyWith(LoadFiles value, $Res Function(LoadFiles) _then) = _$LoadFilesCopyWithImpl;
@useResult
$Res call({
 List<ProjectFile> files, String? activeFilePath, String? mainFilePath
});




}
/// @nodoc
class _$LoadFilesCopyWithImpl<$Res>
    implements $LoadFilesCopyWith<$Res> {
  _$LoadFilesCopyWithImpl(this._self, this._then);

  final LoadFiles _self;
  final $Res Function(LoadFiles) _then;

/// Create a copy of ProjectEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? files = null,Object? activeFilePath = freezed,Object? mainFilePath = freezed,}) {
  return _then(LoadFiles(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<ProjectFile>,activeFilePath: freezed == activeFilePath ? _self.activeFilePath : activeFilePath // ignore: cast_nullable_to_non_nullable
as String?,mainFilePath: freezed == mainFilePath ? _self.mainFilePath : mainFilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
