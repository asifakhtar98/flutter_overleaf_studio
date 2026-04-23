/// Base exception for server-side errors.
class ServerException implements Exception {
  const ServerException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.requestId,
  });

  final String message;
  final int? statusCode;
  final String? errorCode;
  final String? requestId;

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
    this.requestId,
  });

  final String log;
  final String errorCode;
  final double? compilationTime;
  final String? requestId;

  @override
  String toString() => 'CompilationException($errorCode)';
}

/// Exception for authentication errors (missing/invalid API key).
class AuthException implements Exception {
  const AuthException({
    required this.message,
    required this.errorCode,
    this.requestId,
  });

  final String message;
  final String errorCode;
  final String? requestId;

  @override
  String toString() => 'AuthException($errorCode): $message';
}

/// Exception when rate limit is exceeded.
class RateLimitException implements Exception {
  const RateLimitException({required this.message, this.requestId});

  final String message;
  final String? requestId;

  @override
  String toString() => 'RateLimitException: $message';
}

/// Exception when uploaded file is too large.
class UploadTooLargeException implements Exception {
  const UploadTooLargeException({required this.message, this.requestId});

  final String message;
  final String? requestId;

  @override
  String toString() => 'UploadTooLargeException: $message';
}
