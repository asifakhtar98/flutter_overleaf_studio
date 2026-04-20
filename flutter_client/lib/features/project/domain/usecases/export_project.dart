import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_latex_client/features/project/domain/entities/project_file.dart';
import 'package:flutter_latex_client/core/error/failures.dart';

@lazySingleton
class ExportProjectUseCase {
  Future<Either<Failure, void>> call(List<ProjectFile> files) async {
    try {
      final archive = Archive();

      for (final file in files) {
        final bytes = file.bytes;
        archive.addFile(ArchiveFile(file.path, bytes.length, bytes));
      }

      final encoded = ZipEncoder().encode(archive);
      if (encoded.isEmpty) {
        return const Left(Failure.unknown(message: 'Failed to encode ZIP'));
      }

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Project',
        fileName: 'project.zip',
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: Uint8List.fromList(encoded),
      );

      if (result == null) {
        return const Left(Failure.unknown(message: 'Export cancelled'));
      }

      return const Right(null);
    } on Object catch (e) {
      return Left(Failure.unknown(message: 'Failed to export project: $e'));
    }
  }
}
