abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred. Please try again later.']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred. No local data found.']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection. Showing saved rates.']) : super(message);
}

class ParsingFailure extends Failure {
  const ParsingFailure([String message = 'Failed to parse currency data.']) : super(message);
}
