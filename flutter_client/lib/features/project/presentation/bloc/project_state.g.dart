// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectState _$ProjectStateFromJson(Map<String, dynamic> json) =>
    _ProjectState(
      files:
          (json['files'] as List<dynamic>?)
              ?.map((e) => ProjectFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activeFilePath: json['activeFilePath'] as String?,
      mainFilePath: json['mainFilePath'] as String?,
    );

Map<String, dynamic> _$ProjectStateToJson(_ProjectState instance) =>
    <String, dynamic>{
      'files': instance.files,
      'activeFilePath': instance.activeFilePath,
      'mainFilePath': instance.mainFilePath,
    };
