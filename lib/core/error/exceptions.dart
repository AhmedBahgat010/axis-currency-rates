class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server exception occurred']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache exception occurred']);

  @override
  String toString() => message;
}

class ParsingException implements Exception {
  final String message;
  const ParsingException([this.message = 'Parsing exception occurred']);

  @override
  String toString() => message;
}
