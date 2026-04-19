import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/features/compiler/domain/entities/compile_result.dart';
import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';

@lazySingleton
class CompilerRemoteDatasource {
  const CompilerRemoteDatasource(this._dio);

  final Dio _dio;

  Future<CompileResult> compileSingle({
    required String source,
    String engine = 'pdflatex',
    bool draft = false,
  }) async {
    final response = await _dio.post<List<int>>(
      '/api/v1/compile',
      data: {
        'source': source,
        'engine': engine,
        'draft': draft,
      },
      options: Options(responseType: ResponseType.bytes),
    );

    return _parseResponse(response);
  }

  Future<CompileResult> compileProject({
    required List<ProjectFile> files,
    required String mainFile,
    String engine = 'pdflatex',
    bool draft = false,
  }) async {
    final zipBytes = _createZip(files);

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(zipBytes, filename: 'project.zip'),
      'main_file': mainFile,
      'engine': engine,
      'draft': draft.toString(),
    });

    final response = await _dio.post<List<int>>(
      '/api/v1/compile',
      data: formData,
      options: Options(responseType: ResponseType.bytes),
    );

    return _parseResponse(response);
  }

  Uint8List _createZip(List<ProjectFile> files) {
    final archive = Archive();
    for (final file in files) {
      final bytes = utf8.encode(file.content);
      archive.addFile(
        ArchiveFile(file.path, bytes.length, bytes),
      );
    }
    final encoded = ZipEncoder().encode(archive);
    return Uint8List.fromList(encoded);
  }

  CompileResult _parseResponse(Response<List<int>> response) {
    final headers = response.headers;
    return CompileResult(
      pdfBytes: Uint8List.fromList(response.data!),
      log: '',
      compilationTime: double.tryParse(
            headers.value('X-Compilation-Time') ?? '0',
          ) ??
          0,
      engine: headers.value('X-Engine') ?? 'pdflatex',
      warningsCount: int.tryParse(
            headers.value('X-Warnings-Count') ?? '0',
          ) ??
          0,
      passesRun: int.tryParse(
            headers.value('X-Passes-Run') ?? '1',
          ) ??
          1,
      cached: headers.value('X-Cached') == 'true',
    );
  }
}
