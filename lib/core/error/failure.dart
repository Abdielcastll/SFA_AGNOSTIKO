import 'package:equatable/equatable.dart';

///
/// Se usa para todos los fallos que ocurran en la aplicacion
/// excepto para las excepciones externas, como el caso de http, firebase etc
///

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  String get erroMessage => '$message Error: $statusCode';
  const Failure({required this.message, this.statusCode});
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, super.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class AgnostikoFailure extends Failure {
  const AgnostikoFailure({super.statusCode, required super.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.statusCode, required super.message});

  @override
  List<Object?> get props => [message];
}
