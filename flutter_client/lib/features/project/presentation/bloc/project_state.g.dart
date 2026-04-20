// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectFolder _$ProjectFolderFromJson(Map<String, dynamic> json) =>
    _ProjectFolder(
      name: json['name'] as String,
      path: json['path'] as String,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => ProjectFolder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isExpanded: json['isExpanded'] as bool? ?? true,
    );

Map<String, dynamic> _$ProjectFolderToJson(_ProjectFolder instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'children': instance.children,
      'isExpanded': instance.isExpanded,
    };

_ProjectState _$ProjectStateFromJson(Map<String, dynamic> json) =>
    _ProjectState(
      files:
          (json['files'] as List<dynamic>?)
              ?.map((e) => ProjectFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      folders:
          (json['folders'] as List<dynamic>?)
              ?.map((e) => ProjectFolder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activeFilePath: json['activeFilePath'] as String?,
      mainFilePath: json['mainFilePath'] as String?,
    );

Map<String, dynamic> _$ProjectStateToJson(_ProjectState instance) =>
    <String, dynamic>{
      'files': instance.files,
      'folders': instance.folders,
      'activeFilePath': instance.activeFilePath,
      'mainFilePath': instance.mainFilePath,
    };
