import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_file.freezed.dart';
part 'project_file.g.dart';

@freezed
sealed class ProjectFile with _$ProjectFile {
  const factory ProjectFile({
    required String name,
    required String path,
    @Default('') String content,
    @Default(null) String? binaryContentBase64,
    @Default(false) bool isMainFile,
  }) = _ProjectFile;

  factory ProjectFile.fromJson(Map<String, dynamic> json) =>
      _$ProjectFileFromJson(json);
}

extension ProjectFileX on ProjectFile {
  bool get isBinary =>
      binaryContentBase64 != null && binaryContentBase64!.isNotEmpty;

  List<int> get bytes {
    if (binaryContentBase64 != null && binaryContentBase64!.isNotEmpty) {
      return base64Decode(binaryContentBase64!);
    }
    return utf8.encode(content);
  }
}
