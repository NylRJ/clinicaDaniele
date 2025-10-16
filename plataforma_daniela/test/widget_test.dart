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

// --- Imports adicionados para o teste ---
import 'package:plataforma_daniela/features/appointment/domain/entities/appointment_entity.dart';
import 'package:plataforma_daniela/features/appointment/domain/entities/therapist_config_entity.dart';
import 'package:plataforma_daniela/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:plataforma_daniela/features/appointment/presentation/cubit/appointment_cubit.dart';

// Repositório falso para Autenticação (já estava correto)
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
    return right(UserEntity(uid: 'u1', name: 'Tester', email: email, role: 'paciente'));
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({required String name, required String email, required String password}) async {
    return right(UserEntity(uid: 'u2', name: 'New', email: email, role: 'paciente'));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    _controller.add(null);
    return right(null);
  }
}

// --- CLASSE ADICIONADA ---
// Repositório falso para Agendamentos, para satisfazer a dependência do AppointmentCubit.
class _FakeAppointmentRepository implements AppointmentRepository {
  @override
  Future<Either<Failure, void>> cancelAppointment(String appointmentId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> createAppointment({required AppointmentEntity appointment}) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsForTherapist({required String therapistId, required DateTime date}) async {
    return const Right([]);
  }

  @override
  Stream<Either<Failure, List<String>>> getAvailableSlots({required String therapistId, required DateTime date}) {
    return Stream.value(const Right([]));
  }

  @override
  Future<Either<Failure, List<TherapistConfigEntity>>> getTherapists() async {
    return const Right([]);
  }

  @override
  Stream<Either<Failure, List<AppointmentEntity>>> watchAppointmentsForPatient(String patientId) {
    return Stream.value(const Right([]));
  }
}

void main() {
  testWidgets('MyApp renders inside MaterialApp with all Cubits provided', (tester) async {
    // 1. Criamos os repositórios falsos
    final fakeAuthRepository = _FakeAuthRepository();
    final fakeAppointmentRepository = _FakeAppointmentRepository();

    // 2. Criamos os Cubits com os repositórios falsos
    final authCubit = AuthCubit(authRepository: fakeAuthRepository);
    final appointmentCubit = AppointmentCubit(repository: fakeAppointmentRepository);

    // Opcional: garantir um estado inicial previsível
    authCubit.emit(Unauthenticated());

    // 3. O widget agora é envolvido por um MultiBlocProvider
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: authCubit),
          BlocProvider<AppointmentCubit>.value(value: appointmentCubit),
        ],
        child: const MyApp(),
      ),
    );

    // O teste continua o mesmo
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
