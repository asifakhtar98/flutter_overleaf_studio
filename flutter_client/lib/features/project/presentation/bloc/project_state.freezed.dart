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
mixin _$ProjectState {

 List<ProjectFile> get files; String? get activeFilePath; String? get mainFilePath; String get engine; bool get draftMode; bool get isImporting; bool get isExporting; String? get importError;
/// Create a copy of ProjectState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectStateCopyWith<ProjectState> get copyWith => _$ProjectStateCopyWithImpl<ProjectState>(this as ProjectState, _$identity);

  /// Serializes this ProjectState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectState&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.activeFilePath, activeFilePath) || other.activeFilePath == activeFilePath)&&(identical(other.mainFilePath, mainFilePath) || other.mainFilePath == mainFilePath)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.draftMode, draftMode) || other.draftMode == draftMode)&&(identical(other.isImporting, isImporting) || other.isImporting == isImporting)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.importError, importError) || other.importError == importError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files),activeFilePath,mainFilePath,engine,draftMode,isImporting,isExporting,importError);

@override
String toString() {
  return 'ProjectState(files: $files, activeFilePath: $activeFilePath, mainFilePath: $mainFilePath, engine: $engine, draftMode: $draftMode, isImporting: $isImporting, isExporting: $isExporting, importError: $importError)';
}


}

/// @nodoc
abstract mixin class $ProjectStateCopyWith<$Res>  {
  factory $ProjectStateCopyWith(ProjectState value, $Res Function(ProjectState) _then) = _$ProjectStateCopyWithImpl;
@useResult
$Res call({
 List<ProjectFile> files, String? activeFilePath, String? mainFilePath, String engine, bool draftMode, bool isImporting, bool isExporting, String? importError
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
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,Object? activeFilePath = freezed,Object? mainFilePath = freezed,Object? engine = null,Object? draftMode = null,Object? isImporting = null,Object? isExporting = null,Object? importError = freezed,}) {
  return _then(_self.copyWith(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<ProjectFile>,activeFilePath: freezed == activeFilePath ? _self.activeFilePath : activeFilePath // ignore: cast_nullable_to_non_nullable
as String?,mainFilePath: freezed == mainFilePath ? _self.mainFilePath : mainFilePath // ignore: cast_nullable_to_non_nullable
as String?,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,draftMode: null == draftMode ? _self.draftMode : draftMode // ignore: cast_nullable_to_non_nullable
as bool,isImporting: null == isImporting ? _self.isImporting : isImporting // ignore: cast_nullable_to_non_nullable
as bool,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,importError: freezed == importError ? _self.importError : importError // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProjectFile> files,  String? activeFilePath,  String? mainFilePath,  String engine,  bool draftMode,  bool isImporting,  bool isExporting,  String? importError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
return $default(_that.files,_that.activeFilePath,_that.mainFilePath,_that.engine,_that.draftMode,_that.isImporting,_that.isExporting,_that.importError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProjectFile> files,  String? activeFilePath,  String? mainFilePath,  String engine,  bool draftMode,  bool isImporting,  bool isExporting,  String? importError)  $default,) {final _that = this;
switch (_that) {
case _ProjectState():
return $default(_that.files,_that.activeFilePath,_that.mainFilePath,_that.engine,_that.draftMode,_that.isImporting,_that.isExporting,_that.importError);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProjectFile> files,  String? activeFilePath,  String? mainFilePath,  String engine,  bool draftMode,  bool isImporting,  bool isExporting,  String? importError)?  $default,) {final _that = this;
switch (_that) {
case _ProjectState() when $default != null:
return $default(_that.files,_that.activeFilePath,_that.mainFilePath,_that.engine,_that.draftMode,_that.isImporting,_that.isExporting,_that.importError);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectState implements ProjectState {
  const _ProjectState({final  List<ProjectFile> files = const [], this.activeFilePath, this.mainFilePath, this.engine = 'pdflatex', this.draftMode = false, this.isImporting = false, this.isExporting = false, this.importError}): _files = files;
  factory _ProjectState.fromJson(Map<String, dynamic> json) => _$ProjectStateFromJson(json);

 final  List<ProjectFile> _files;
@override@JsonKey() List<ProjectFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override final  String? activeFilePath;
@override final  String? mainFilePath;
@override@JsonKey() final  String engine;
@override@JsonKey() final  bool draftMode;
@override@JsonKey() final  bool isImporting;
@override@JsonKey() final  bool isExporting;
@override final  String? importError;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectState&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.activeFilePath, activeFilePath) || other.activeFilePath == activeFilePath)&&(identical(other.mainFilePath, mainFilePath) || other.mainFilePath == mainFilePath)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.draftMode, draftMode) || other.draftMode == draftMode)&&(identical(other.isImporting, isImporting) || other.isImporting == isImporting)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.importError, importError) || other.importError == importError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files),activeFilePath,mainFilePath,engine,draftMode,isImporting,isExporting,importError);

@override
String toString() {
  return 'ProjectState(files: $files, activeFilePath: $activeFilePath, mainFilePath: $mainFilePath, engine: $engine, draftMode: $draftMode, isImporting: $isImporting, isExporting: $isExporting, importError: $importError)';
}


}

/// @nodoc
abstract mixin class _$ProjectStateCopyWith<$Res> implements $ProjectStateCopyWith<$Res> {
  factory _$ProjectStateCopyWith(_ProjectState value, $Res Function(_ProjectState) _then) = __$ProjectStateCopyWithImpl;
@override @useResult
$Res call({
 List<ProjectFile> files, String? activeFilePath, String? mainFilePath, String engine, bool draftMode, bool isImporting, bool isExporting, String? importError
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
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,Object? activeFilePath = freezed,Object? mainFilePath = freezed,Object? engine = null,Object? draftMode = null,Object? isImporting = null,Object? isExporting = null,Object? importError = freezed,}) {
  return _then(_ProjectState(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<ProjectFile>,activeFilePath: freezed == activeFilePath ? _self.activeFilePath : activeFilePath // ignore: cast_nullable_to_non_nullable
as String?,mainFilePath: freezed == mainFilePath ? _self.mainFilePath : mainFilePath // ignore: cast_nullable_to_non_nullable
as String?,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,draftMode: null == draftMode ? _self.draftMode : draftMode // ignore: cast_nullable_to_non_nullable
as bool,isImporting: null == isImporting ? _self.isImporting : isImporting // ignore: cast_nullable_to_non_nullable
as bool,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,importError: freezed == importError ? _self.importError : importError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
