// Basic smoke test for the root widget, ensuring required providers exist.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:plataforma_daniela/main.dart';
import 'package:plataforma_daniela/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plataforma_daniela/features/auth/presentation/cubit/auth_state.dart';
import 'package:plataforma_daniela/features/auth/domain/repositories/auth_repository.dart';
import 'package:plataforma_daniela/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:plataforma_daniela/core/error/failures.dart';

// Minimal fake AuthRepository to satisfy AuthCubit during widget test.
class _FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<UserEntity?>.broadcast();

  _FakeAuthRepository({bool startAuthenticated = false}) {
    if (startAuthenticated) {
      _controller.add(const UserEntity(uid: 'u1', name: 'Tester', email: 't@t.com', role: 'paciente'));
    } else {
      _controller.add(null);
    }
  }

  @override
  Stream<UserEntity?> get user => _controller.stream;

  @override
  Future<Either<Failure, UserEntity>> signIn({required String email, required String password}) async {
    return right(const UserEntity(uid: 'u1', name: 'Tester', email: email, role: 'paciente'));
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({required String name, required String email, required String password}) async {
    return right(const UserEntity(uid: 'u2', name: 'New', email: email, role: 'paciente'));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    _controller.add(null);
    return right(null);
  }
}

void main() {
  testWidgets('MyApp renders inside MaterialApp with AuthCubit provided', (tester) async {
    final authCubit = AuthCubit(authRepository: _FakeAuthRepository());
    // Optional: ensure a non-null state for predictable UI
    authCubit.emit(Unauthenticated());

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: const MyApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
