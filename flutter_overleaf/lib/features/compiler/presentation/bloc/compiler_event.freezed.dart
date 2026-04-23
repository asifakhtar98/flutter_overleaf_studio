// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compiler_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompilerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompilerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompilerEvent()';
}


}

/// @nodoc
class $CompilerEventCopyWith<$Res>  {
$CompilerEventCopyWith(CompilerEvent _, $Res Function(CompilerEvent) __);
}


/// Adds pattern-matching-related methods to [CompilerEvent].
extension CompilerEventPatterns on CompilerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CompileRequested value)?  compileRequested,TResult Function( CompileReset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CompileRequested() when compileRequested != null:
return compileRequested(_that);case CompileReset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CompileRequested value)  compileRequested,required TResult Function( CompileReset value)  reset,}){
final _that = this;
switch (_that) {
case CompileRequested():
return compileRequested(_that);case CompileReset():
return reset(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CompileRequested value)?  compileRequested,TResult? Function( CompileReset value)?  reset,}){
final _that = this;
switch (_that) {
case CompileRequested() when compileRequested != null:
return compileRequested(_that);case CompileReset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Engine engine,  bool draft,  List<ProjectFile> files,  String mainFile,  bool enableCache)?  compileRequested,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CompileRequested() when compileRequested != null:
return compileRequested(_that.engine,_that.draft,_that.files,_that.mainFile,_that.enableCache);case CompileReset() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Engine engine,  bool draft,  List<ProjectFile> files,  String mainFile,  bool enableCache)  compileRequested,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case CompileRequested():
return compileRequested(_that.engine,_that.draft,_that.files,_that.mainFile,_that.enableCache);case CompileReset():
return reset();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Engine engine,  bool draft,  List<ProjectFile> files,  String mainFile,  bool enableCache)?  compileRequested,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case CompileRequested() when compileRequested != null:
return compileRequested(_that.engine,_that.draft,_that.files,_that.mainFile,_that.enableCache);case CompileReset() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class CompileRequested implements CompilerEvent {
  const CompileRequested({required this.engine, required this.draft, required final  List<ProjectFile> files, required this.mainFile, this.enableCache = true}): _files = files;
  

 final  Engine engine;
 final  bool draft;
 final  List<ProjectFile> _files;
 List<ProjectFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

 final  String mainFile;
@JsonKey() final  bool enableCache;

/// Create a copy of CompilerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompileRequestedCopyWith<CompileRequested> get copyWith => _$CompileRequestedCopyWithImpl<CompileRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompileRequested&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.draft, draft) || other.draft == draft)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.mainFile, mainFile) || other.mainFile == mainFile)&&(identical(other.enableCache, enableCache) || other.enableCache == enableCache));
}


@override
int get hashCode => Object.hash(runtimeType,engine,draft,const DeepCollectionEquality().hash(_files),mainFile,enableCache);

@override
String toString() {
  return 'CompilerEvent.compileRequested(engine: $engine, draft: $draft, files: $files, mainFile: $mainFile, enableCache: $enableCache)';
}


}

/// @nodoc
abstract mixin class $CompileRequestedCopyWith<$Res> implements $CompilerEventCopyWith<$Res> {
  factory $CompileRequestedCopyWith(CompileRequested value, $Res Function(CompileRequested) _then) = _$CompileRequestedCopyWithImpl;
@useResult
$Res call({
 Engine engine, bool draft, List<ProjectFile> files, String mainFile, bool enableCache
});




}
/// @nodoc
class _$CompileRequestedCopyWithImpl<$Res>
    implements $CompileRequestedCopyWith<$Res> {
  _$CompileRequestedCopyWithImpl(this._self, this._then);

  final CompileRequested _self;
  final $Res Function(CompileRequested) _then;

/// Create a copy of CompilerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? engine = null,Object? draft = null,Object? files = null,Object? mainFile = null,Object? enableCache = null,}) {
  return _then(CompileRequested(
engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as Engine,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<ProjectFile>,mainFile: null == mainFile ? _self.mainFile : mainFile // ignore: cast_nullable_to_non_nullable
as String,enableCache: null == enableCache ? _self.enableCache : enableCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CompileReset implements CompilerEvent {
  const CompileReset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompileReset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompilerEvent.reset()';
}


}




// dart format on
