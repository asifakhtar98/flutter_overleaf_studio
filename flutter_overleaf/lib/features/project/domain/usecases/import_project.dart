import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_overleaf/core/constants/app_constants.dart';
import 'package:flutter_overleaf/features/project/domain/entities/project_file.dart';
import 'package:flutter_overleaf/core/error/failures.dart';

@lazySingleton
class ImportProjectUseCase {
  Future<Either<Failure, List<ProjectFile>>> call({
    List<int>? bytes,
    bool fromPicker = true,
  }) async {
    try {
      var zipBytes = bytes;

      if (zipBytes == null && fromPicker) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['zip'],
          withData: true,
        );

        if (result == null || result.files.isEmpty) {
          return const Left(Failure.unknown(message: 'No file selected'));
        }

        final file = result.files.first;
        if (file.bytes == null) {
          return const Left(Failure.unknown(message: 'Could not read file'));
        }
        zipBytes = file.bytes;
      }

      if (zipBytes == null) {
        return const Left(Failure.unknown(message: 'No file provided'));
      }

      final archive = ZipDecoder().decodeBytes(zipBytes);
      final files = <ProjectFile>[];

      for (final archiveFile in archive) {
        if (archiveFile.isFile) {
          final name = archiveFile.name.split('/').last;
          if (name.isEmpty) continue;

          if (isBinaryFileName(name)) {
            files.add(
              ProjectFile(
                name: name,
                path: archiveFile.name,
                content: '',
                binaryContentBase64: base64Encode(
                  archiveFile.content as List<int>,
                ),
                isMainFile: name.toLowerCase() == 'main.tex',
              ),
            );
          } else {
            final content = utf8.decode(
              archiveFile.content as List<int>,
              allowMalformed: true,
            );
            files.add(
              ProjectFile(
                name: name,
                path: archiveFile.name,
                content: content,
                isMainFile: name.toLowerCase() == 'main.tex',
              ),
            );
          }
        }
      }

      if (files.isEmpty) {
        return const Left(Failure.unknown(message: 'No files found in ZIP'));
      }

      return Right(files);
    } on Object catch (e) {
      return Left(Failure.unknown(message: 'Failed to import project: $e'));
    }
  }
}
