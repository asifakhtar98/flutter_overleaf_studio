// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compile_project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompileProjectParams {

 List<ProjectFile> get files; String get mainFile; String get engine; bool get draft;
/// Create a copy of CompileProjectParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompileProjectParamsCopyWith<CompileProjectParams> get copyWith => _$CompileProjectParamsCopyWithImpl<CompileProjectParams>(this as CompileProjectParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompileProjectParams&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.mainFile, mainFile) || other.mainFile == mainFile)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files),mainFile,engine,draft);

@override
String toString() {
  return 'CompileProjectParams(files: $files, mainFile: $mainFile, engine: $engine, draft: $draft)';
}


}

/// @nodoc
abstract mixin class $CompileProjectParamsCopyWith<$Res>  {
  factory $CompileProjectParamsCopyWith(CompileProjectParams value, $Res Function(CompileProjectParams) _then) = _$CompileProjectParamsCopyWithImpl;
@useResult
$Res call({
 List<ProjectFile> files, String mainFile, String engine, bool draft
});




}
/// @nodoc
class _$CompileProjectParamsCopyWithImpl<$Res>
    implements $CompileProjectParamsCopyWith<$Res> {
  _$CompileProjectParamsCopyWithImpl(this._self, this._then);

  final CompileProjectParams _self;
  final $Res Function(CompileProjectParams) _then;

/// Create a copy of CompileProjectParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,Object? mainFile = null,Object? engine = null,Object? draft = null,}) {
  return _then(_self.copyWith(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<ProjectFile>,mainFile: null == mainFile ? _self.mainFile : mainFile // ignore: cast_nullable_to_non_nullable
as String,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CompileProjectParams].
extension CompileProjectParamsPatterns on CompileProjectParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompileProjectParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompileProjectParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompileProjectParams value)  $default,){
final _that = this;
switch (_that) {
case _CompileProjectParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompileProjectParams value)?  $default,){
final _that = this;
switch (_that) {
case _CompileProjectParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProjectFile> files,  String mainFile,  String engine,  bool draft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompileProjectParams() when $default != null:
return $default(_that.files,_that.mainFile,_that.engine,_that.draft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProjectFile> files,  String mainFile,  String engine,  bool draft)  $default,) {final _that = this;
switch (_that) {
case _CompileProjectParams():
return $default(_that.files,_that.mainFile,_that.engine,_that.draft);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProjectFile> files,  String mainFile,  String engine,  bool draft)?  $default,) {final _that = this;
switch (_that) {
case _CompileProjectParams() when $default != null:
return $default(_that.files,_that.mainFile,_that.engine,_that.draft);case _:
  return null;

}
}

}

/// @nodoc


class _CompileProjectParams implements CompileProjectParams {
  const _CompileProjectParams({required final  List<ProjectFile> files, required this.mainFile, this.engine = 'pdflatex', this.draft = false}): _files = files;
  

 final  List<ProjectFile> _files;
@override List<ProjectFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override final  String mainFile;
@override@JsonKey() final  String engine;
@override@JsonKey() final  bool draft;

/// Create a copy of CompileProjectParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompileProjectParamsCopyWith<_CompileProjectParams> get copyWith => __$CompileProjectParamsCopyWithImpl<_CompileProjectParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompileProjectParams&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.mainFile, mainFile) || other.mainFile == mainFile)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.draft, draft) || other.draft == draft));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files),mainFile,engine,draft);

@override
String toString() {
  return 'CompileProjectParams(files: $files, mainFile: $mainFile, engine: $engine, draft: $draft)';
}


}

/// @nodoc
abstract mixin class _$CompileProjectParamsCopyWith<$Res> implements $CompileProjectParamsCopyWith<$Res> {
  factory _$CompileProjectParamsCopyWith(_CompileProjectParams value, $Res Function(_CompileProjectParams) _then) = __$CompileProjectParamsCopyWithImpl;
@override @useResult
$Res call({
 List<ProjectFile> files, String mainFile, String engine, bool draft
});




}
/// @nodoc
class __$CompileProjectParamsCopyWithImpl<$Res>
    implements _$CompileProjectParamsCopyWith<$Res> {
  __$CompileProjectParamsCopyWithImpl(this._self, this._then);

  final _CompileProjectParams _self;
  final $Res Function(_CompileProjectParams) _then;

/// Create a copy of CompileProjectParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,Object? mainFile = null,Object? engine = null,Object? draft = null,}) {
  return _then(_CompileProjectParams(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<ProjectFile>,mainFile: null == mainFile ? _self.mainFile : mainFile // ignore: cast_nullable_to_non_nullable
as String,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
