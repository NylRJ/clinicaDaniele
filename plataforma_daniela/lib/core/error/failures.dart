// ARQUIVO: lib/core/error/failures.dart

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Falha geral do servidor.
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Falha de cache.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
