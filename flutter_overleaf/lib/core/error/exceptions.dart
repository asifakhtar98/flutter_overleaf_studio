/// Base exception for server-side errors.
class ServerException implements Exception {
  const ServerException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  final String message;
  final int? statusCode;
  final String? errorCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Exception for network connectivity issues.
class NetworkException implements Exception {
  const NetworkException({required this.message});

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception for compilation failures with full log.
class CompilationException implements Exception {
  const CompilationException({
    required this.log,
    required this.errorCode,
    this.compilationTime,
  });

  final String log;
  final String errorCode;
  final double? compilationTime;

  @override
  String toString() => 'CompilationException($errorCode)';
}
