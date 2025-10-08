import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

// Este arquivo estava faltando, por isso o erro 'Undefined class AuthRepository'
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({required String email, required String password});
  Future<Either<Failure, UserEntity>> signUp({required String name, required String email, required String password});
  Future<Either<Failure, void>> signOut();
  Stream<UserEntity?> get user;
}
