/// Exception thrown when a server-related issue occurs.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
  
  @override
  String toString() => 'ServerException: $message (StatusCode: $statusCode)';
}

/// Exception thrown when local data caching fails.
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

/// Exception thrown when network connectivity is absent.
class NetworkException implements Exception {}
