// ARQUIVO: lib/core/error/exceptions.dart
// OBJETIVO: Define exceções personalizadas para a camada de dados.

class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Ocorreu um erro no servidor.'});
}

class CacheException implements Exception {}
