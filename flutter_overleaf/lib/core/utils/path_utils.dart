final _invalidChars = RegExp(r'[<>:"|?*\\/\x00-\x1F]');

bool isValidFileName(String name) {
  return !_invalidChars.hasMatch(name) && name.isNotEmpty;
}

bool isValidFolderName(String name) {
  return isValidFileName(name);
}

String replaceLastPathSegment(String oldPath, String newName) {
  if (!oldPath.contains('/')) {
    return newName;
  }
  final dir = '${oldPath.substring(0, oldPath.lastIndexOf('/'))}/';
  return '$dir$newName';
}

String buildFullPath(String prefix, String name) {
  return prefix.isEmpty ? name : '$prefix/$name';
}
