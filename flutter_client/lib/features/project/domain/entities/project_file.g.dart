// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectFile _$ProjectFileFromJson(Map<String, dynamic> json) => _ProjectFile(
  name: json['name'] as String,
  path: json['path'] as String,
  content: json['content'] as String,
  isMainFile: json['isMainFile'] as bool? ?? false,
);

Map<String, dynamic> _$ProjectFileToJson(_ProjectFile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'content': instance.content,
      'isMainFile': instance.isMainFile,
    };

ProjectFileNode _$ProjectFileNodeFromJson(Map<String, dynamic> json) =>
    ProjectFileNode(
      file: ProjectFile.fromJson(json['file'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ProjectFileNodeToJson(ProjectFileNode instance) =>
    <String, dynamic>{'file': instance.file, 'runtimeType': instance.$type};

ProjectFolderNode _$ProjectFolderNodeFromJson(Map<String, dynamic> json) =>
    ProjectFolderNode(
      name: json['name'] as String,
      path: json['path'] as String,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => ProjectNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isExpanded: json['isExpanded'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ProjectFolderNodeToJson(ProjectFolderNode instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'children': instance.children,
      'isExpanded': instance.isExpanded,
      'runtimeType': instance.$type,
    };
