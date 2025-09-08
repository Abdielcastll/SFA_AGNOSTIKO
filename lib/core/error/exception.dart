import 'package:equatable/equatable.dart';

/// Error types used across the application.
enum Error {
  agnostiko('errAgnostiko'),
  requestFailed('errRequestFailed'),
  badResponseCode('errResponseCode'),
  emptyToken('errEmptyToken'),
  expiredToken('errExpiredToken'),
  networkError('Error de red', isFatal: true);

  final String value;
  final bool isFatal;

  const Error(this.value, {this.isFatal = false});
}

///
/// Represents an exception from an external dependency (like HTTP, Agnostiko, etc.).
/// RepositoryImpl should catch these and convert them into known application-level failures.
///
class ApiException extends Equatable implements Exception {
  final String message;
  final int statusCode;

  const ApiException({
    required this.message,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheException implements Exception {
  final Error error;

  CacheException(this.error);

  @override
  String toString() => 'CacheException: ${error.value}';
}

class AgnostikoException implements Exception {
  final Error error;

  AgnostikoException(this.error);

  @override
  String toString() => 'AgnostikoException: ${error.value}';
}

class ServerException implements Exception {
  final Error error;

  ServerException(this.error);

  @override
  String toString() => 'ServerException: ${error.value}';
}
