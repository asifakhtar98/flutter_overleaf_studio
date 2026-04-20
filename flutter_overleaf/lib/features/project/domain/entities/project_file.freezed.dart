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

 String get name; String get path; String get content; String? get binaryContentBase64; bool get isMainFile;
/// Create a copy of ProjectFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectFileCopyWith<ProjectFile> get copyWith => _$ProjectFileCopyWithImpl<ProjectFile>(this as ProjectFile, _$identity);

  /// Serializes this ProjectFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectFile&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.content, content) || other.content == content)&&(identical(other.binaryContentBase64, binaryContentBase64) || other.binaryContentBase64 == binaryContentBase64)&&(identical(other.isMainFile, isMainFile) || other.isMainFile == isMainFile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path,content,binaryContentBase64,isMainFile);

@override
String toString() {
  return 'ProjectFile(name: $name, path: $path, content: $content, binaryContentBase64: $binaryContentBase64, isMainFile: $isMainFile)';
}


}

/// @nodoc
abstract mixin class $ProjectFileCopyWith<$Res>  {
  factory $ProjectFileCopyWith(ProjectFile value, $Res Function(ProjectFile) _then) = _$ProjectFileCopyWithImpl;
@useResult
$Res call({
 String name, String path, String content, String? binaryContentBase64, bool isMainFile
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = null,Object? content = null,Object? binaryContentBase64 = freezed,Object? isMainFile = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,binaryContentBase64: freezed == binaryContentBase64 ? _self.binaryContentBase64 : binaryContentBase64 // ignore: cast_nullable_to_non_nullable
as String?,isMainFile: null == isMainFile ? _self.isMainFile : isMainFile // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String path,  String content,  String? binaryContentBase64,  bool isMainFile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectFile() when $default != null:
return $default(_that.name,_that.path,_that.content,_that.binaryContentBase64,_that.isMainFile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String path,  String content,  String? binaryContentBase64,  bool isMainFile)  $default,) {final _that = this;
switch (_that) {
case _ProjectFile():
return $default(_that.name,_that.path,_that.content,_that.binaryContentBase64,_that.isMainFile);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String path,  String content,  String? binaryContentBase64,  bool isMainFile)?  $default,) {final _that = this;
switch (_that) {
case _ProjectFile() when $default != null:
return $default(_that.name,_that.path,_that.content,_that.binaryContentBase64,_that.isMainFile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectFile implements ProjectFile {
  const _ProjectFile({required this.name, required this.path, this.content = '', this.binaryContentBase64 = null, this.isMainFile = false});
  factory _ProjectFile.fromJson(Map<String, dynamic> json) => _$ProjectFileFromJson(json);

@override final  String name;
@override final  String path;
@override@JsonKey() final  String content;
@override@JsonKey() final  String? binaryContentBase64;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectFile&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.content, content) || other.content == content)&&(identical(other.binaryContentBase64, binaryContentBase64) || other.binaryContentBase64 == binaryContentBase64)&&(identical(other.isMainFile, isMainFile) || other.isMainFile == isMainFile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,path,content,binaryContentBase64,isMainFile);

@override
String toString() {
  return 'ProjectFile(name: $name, path: $path, content: $content, binaryContentBase64: $binaryContentBase64, isMainFile: $isMainFile)';
}


}

/// @nodoc
abstract mixin class _$ProjectFileCopyWith<$Res> implements $ProjectFileCopyWith<$Res> {
  factory _$ProjectFileCopyWith(_ProjectFile value, $Res Function(_ProjectFile) _then) = __$ProjectFileCopyWithImpl;
@override @useResult
$Res call({
 String name, String path, String content, String? binaryContentBase64, bool isMainFile
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? content = null,Object? binaryContentBase64 = freezed,Object? isMainFile = null,}) {
  return _then(_ProjectFile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,binaryContentBase64: freezed == binaryContentBase64 ? _self.binaryContentBase64 : binaryContentBase64 // ignore: cast_nullable_to_non_nullable
as String?,isMainFile: null == isMainFile ? _self.isMainFile : isMainFile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
