// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectFile _$ProjectFileFromJson(Map<String, dynamic> json) => _ProjectFile(
  name: json['name'] as String,
  path: json['path'] as String,
  content: json['content'] as String? ?? '',
  binaryContentBase64: json['binaryContentBase64'] as String? ?? null,
  isMainFile: json['isMainFile'] as bool? ?? false,
);

Map<String, dynamic> _$ProjectFileToJson(_ProjectFile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'content': instance.content,
      'binaryContentBase64': instance.binaryContentBase64,
      'isMainFile': instance.isMainFile,
    };
