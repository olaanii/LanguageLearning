class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Error']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache Error']);
}
