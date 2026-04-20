import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

      final zipBytes = Uint8List.fromList(encoded);

      if (kIsWeb) {
        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Export Project',
          fileName: 'project.zip',
          type: FileType.custom,
          allowedExtensions: ['zip'],
          bytes: zipBytes,
        );

        if (result == null) {
          return const Left(Failure.unknown(message: 'Export cancelled'));
        }
      } else {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/project.zip');
        await tempFile.writeAsBytes(zipBytes);

        await SharePlus.instance.share(
          ShareParams(files: [XFile(tempFile.path)], text: 'LaTeX Project'),
        );
      }

      return const Right(null);
    } on Object catch (e) {
      return Left(Failure.unknown(message: 'Failed to export project: $e'));
    }
  }
}
