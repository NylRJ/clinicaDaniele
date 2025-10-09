// ARQUIVO: lib/features/auth/data/repositories/auth_repository_impl.dart
// O caminho para este ficheiro está correto.

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_firebase_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource authFirebaseDataSource;

  AuthRepositoryImpl({required this.authFirebaseDataSource});

  @override
  Future<Either<Failure, UserEntity>> signIn({required String email, required String password}) async {
    try {
      final user = await authFirebaseDataSource.signIn(email: email, password: password);
      return Right(user);
    } on ServerException catch (e) {
      // CORREÇÃO APLICADA AQUI: Adicionado o nome do parâmetro 'message:'
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({required String name, required String email, required String password}) async {
    try {
      final user = await authFirebaseDataSource.signUp(name: name, email: email, password: password);
      return Right(user);
    } on ServerException catch (e) {
      // Esta parte já estava correta!
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authFirebaseDataSource.signOut();
      // O método signOut retorna um Future<void>, então o lado direito (Right) deve ser nulo.
      return const Right(null);
    } on Exception {
      return Left(const ServerFailure(message: 'Ocorreu um erro ao terminar a sessão.'));
    }
  }

  @override
  Stream<UserEntity?> get user => authFirebaseDataSource.user;
}
