import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';
import 'package:flutter_latex_client/core/error/failures.dart';

@lazySingleton
class ImportProjectUseCase {
  Future<Either<Failure, List<ProjectFile>>> call() async {
    try {
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

      final archive = ZipDecoder().decodeBytes(file.bytes!);
      final files = <ProjectFile>[];

      for (final archiveFile in archive) {
        if (archiveFile.isFile) {
          final content = utf8.decode(
            archiveFile.content as List<int>,
            allowMalformed: true,
          );
          final name = archiveFile.name.split('/').last;

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

      if (files.isEmpty) {
        return const Left(Failure.unknown(message: 'No files found in ZIP'));
      }

      return Right(files);
    } on Object catch (e) {
      return Left(Failure.unknown(message: 'Failed to import project: $e'));
    }
  }
}
