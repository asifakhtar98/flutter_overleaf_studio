// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectFile {

 String get name; String get path; String get content; bool get isMainFile;
/// Create a copy of ProjectFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectFileCopyWith<ProjectFile> get copyWith => _$ProjectFileCopyWithImpl<ProjectFile>(this as ProjectFile, _$identity);

  /// Serializes this ProjectFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectFile&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.content, content) || other.content == content)&&(identical(other.isMainFile, isMainFile) || other.isMainFile == isMainFile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path,content,isMainFile);

@override
String toString() {
  return 'ProjectFile(name: $name, path: $path, content: $content, isMainFile: $isMainFile)';
}


}

/// @nodoc
abstract mixin class $ProjectFileCopyWith<$Res>  {
  factory $ProjectFileCopyWith(ProjectFile value, $Res Function(ProjectFile) _then) = _$ProjectFileCopyWithImpl;
@useResult
$Res call({
 String name, String path, String content, bool isMainFile
});




}
/// @nodoc
class _$ProjectFileCopyWithImpl<$Res>
    implements $ProjectFileCopyWith<$Res> {
  _$ProjectFileCopyWithImpl(this._self, this._then);

  final ProjectFile _self;
  final $Res Function(ProjectFile) _then;

/// Create a copy of ProjectFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = null,Object? content = null,Object? isMainFile = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isMainFile: null == isMainFile ? _self.isMainFile : isMainFile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectFile].
extension ProjectFilePatterns on ProjectFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectFile value)  $default,){
final _that = this;
switch (_that) {
case _ProjectFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectFile value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String path,  String content,  bool isMainFile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectFile() when $default != null:
return $default(_that.name,_that.path,_that.content,_that.isMainFile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String path,  String content,  bool isMainFile)  $default,) {final _that = this;
switch (_that) {
case _ProjectFile():
return $default(_that.name,_that.path,_that.content,_that.isMainFile);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String path,  String content,  bool isMainFile)?  $default,) {final _that = this;
switch (_that) {
case _ProjectFile() when $default != null:
return $default(_that.name,_that.path,_that.content,_that.isMainFile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectFile implements ProjectFile {
  const _ProjectFile({required this.name, required this.path, required this.content, this.isMainFile = false});
  factory _ProjectFile.fromJson(Map<String, dynamic> json) => _$ProjectFileFromJson(json);

@override final  String name;
@override final  String path;
@override final  String content;
@override@JsonKey() final  bool isMainFile;

/// Create a copy of ProjectFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectFileCopyWith<_ProjectFile> get copyWith => __$ProjectFileCopyWithImpl<_ProjectFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectFile&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.content, content) || other.content == content)&&(identical(other.isMainFile, isMainFile) || other.isMainFile == isMainFile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path,content,isMainFile);

@override
String toString() {
  return 'ProjectFile(name: $name, path: $path, content: $content, isMainFile: $isMainFile)';
}


}

/// @nodoc
abstract mixin class _$ProjectFileCopyWith<$Res> implements $ProjectFileCopyWith<$Res> {
  factory _$ProjectFileCopyWith(_ProjectFile value, $Res Function(_ProjectFile) _then) = __$ProjectFileCopyWithImpl;
@override @useResult
$Res call({
 String name, String path, String content, bool isMainFile
});




}
/// @nodoc
class __$ProjectFileCopyWithImpl<$Res>
    implements _$ProjectFileCopyWith<$Res> {
  __$ProjectFileCopyWithImpl(this._self, this._then);

  final _ProjectFile _self;
  final $Res Function(_ProjectFile) _then;

/// Create a copy of ProjectFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? content = null,Object? isMainFile = null,}) {
  return _then(_ProjectFile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isMainFile: null == isMainFile ? _self.isMainFile : isMainFile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

ProjectNode _$ProjectNodeFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'file':
          return ProjectFileNode.fromJson(
            json
          );
                case 'folder':
          return ProjectFolderNode.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'ProjectNode',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$ProjectNode {



  /// Serializes this ProjectNode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectNode);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectNode()';
}


}

/// @nodoc
class $ProjectNodeCopyWith<$Res>  {
$ProjectNodeCopyWith(ProjectNode _, $Res Function(ProjectNode) __);
}


/// Adds pattern-matching-related methods to [ProjectNode].
extension ProjectNodePatterns on ProjectNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProjectFileNode value)?  file,TResult Function( ProjectFolderNode value)?  folder,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProjectFileNode() when file != null:
return file(_that);case ProjectFolderNode() when folder != null:
return folder(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProjectFileNode value)  file,required TResult Function( ProjectFolderNode value)  folder,}){
final _that = this;
switch (_that) {
case ProjectFileNode():
return file(_that);case ProjectFolderNode():
return folder(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProjectFileNode value)?  file,TResult? Function( ProjectFolderNode value)?  folder,}){
final _that = this;
switch (_that) {
case ProjectFileNode() when file != null:
return file(_that);case ProjectFolderNode() when folder != null:
return folder(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ProjectFile file)?  file,TResult Function( String name,  String path,  List<ProjectNode> children,  bool isExpanded)?  folder,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProjectFileNode() when file != null:
return file(_that.file);case ProjectFolderNode() when folder != null:
return folder(_that.name,_that.path,_that.children,_that.isExpanded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ProjectFile file)  file,required TResult Function( String name,  String path,  List<ProjectNode> children,  bool isExpanded)  folder,}) {final _that = this;
switch (_that) {
case ProjectFileNode():
return file(_that.file);case ProjectFolderNode():
return folder(_that.name,_that.path,_that.children,_that.isExpanded);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ProjectFile file)?  file,TResult? Function( String name,  String path,  List<ProjectNode> children,  bool isExpanded)?  folder,}) {final _that = this;
switch (_that) {
case ProjectFileNode() when file != null:
return file(_that.file);case ProjectFolderNode() when folder != null:
return folder(_that.name,_that.path,_that.children,_that.isExpanded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ProjectFileNode implements ProjectNode {
  const ProjectFileNode({required this.file, final  String? $type}): $type = $type ?? 'file';
  factory ProjectFileNode.fromJson(Map<String, dynamic> json) => _$ProjectFileNodeFromJson(json);

 final  ProjectFile file;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ProjectNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectFileNodeCopyWith<ProjectFileNode> get copyWith => _$ProjectFileNodeCopyWithImpl<ProjectFileNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectFileNodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectFileNode&&(identical(other.file, file) || other.file == file));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'ProjectNode.file(file: $file)';
}


}

/// @nodoc
abstract mixin class $ProjectFileNodeCopyWith<$Res> implements $ProjectNodeCopyWith<$Res> {
  factory $ProjectFileNodeCopyWith(ProjectFileNode value, $Res Function(ProjectFileNode) _then) = _$ProjectFileNodeCopyWithImpl;
@useResult
$Res call({
 ProjectFile file
});


$ProjectFileCopyWith<$Res> get file;

}
/// @nodoc
class _$ProjectFileNodeCopyWithImpl<$Res>
    implements $ProjectFileNodeCopyWith<$Res> {
  _$ProjectFileNodeCopyWithImpl(this._self, this._then);

  final ProjectFileNode _self;
  final $Res Function(ProjectFileNode) _then;

/// Create a copy of ProjectNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(ProjectFileNode(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as ProjectFile,
  ));
}

/// Create a copy of ProjectNode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectFileCopyWith<$Res> get file {
  
  return $ProjectFileCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ProjectFolderNode implements ProjectNode {
  const ProjectFolderNode({required this.name, required this.path, final  List<ProjectNode> children = const [], this.isExpanded = false, final  String? $type}): _children = children,$type = $type ?? 'folder';
  factory ProjectFolderNode.fromJson(Map<String, dynamic> json) => _$ProjectFolderNodeFromJson(json);

 final  String name;
 final  String path;
 final  List<ProjectNode> _children;
@JsonKey() List<ProjectNode> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@JsonKey() final  bool isExpanded;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ProjectNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectFolderNodeCopyWith<ProjectFolderNode> get copyWith => _$ProjectFolderNodeCopyWithImpl<ProjectFolderNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectFolderNodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectFolderNode&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other._children, _children)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path,const DeepCollectionEquality().hash(_children),isExpanded);

@override
String toString() {
  return 'ProjectNode.folder(name: $name, path: $path, children: $children, isExpanded: $isExpanded)';
}


}

/// @nodoc
abstract mixin class $ProjectFolderNodeCopyWith<$Res> implements $ProjectNodeCopyWith<$Res> {
  factory $ProjectFolderNodeCopyWith(ProjectFolderNode value, $Res Function(ProjectFolderNode) _then) = _$ProjectFolderNodeCopyWithImpl;
@useResult
$Res call({
 String name, String path, List<ProjectNode> children, bool isExpanded
});




}
/// @nodoc
class _$ProjectFolderNodeCopyWithImpl<$Res>
    implements $ProjectFolderNodeCopyWith<$Res> {
  _$ProjectFolderNodeCopyWithImpl(this._self, this._then);

  final ProjectFolderNode _self;
  final $Res Function(ProjectFolderNode) _then;

/// Create a copy of ProjectNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? children = null,Object? isExpanded = null,}) {
  return _then(ProjectFolderNode(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ProjectNode>,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
