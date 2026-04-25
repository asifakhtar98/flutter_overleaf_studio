import 'dart:typed_data';

/// Lightweight DTO carrying raw bytes from the file picker / drag-drop
/// before they are classified as text or binary and stored as a project file.
class UploadedFileData {
  const UploadedFileData({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;
}
