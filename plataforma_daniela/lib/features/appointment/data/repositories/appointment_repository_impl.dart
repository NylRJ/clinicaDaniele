// ARQUIVO: lib/features/appointment/domain/repositories/appointment_repository.dart
//
// OBJETIVO: Este arquivo define o "contrato" abstrato para todas as
// operações relacionadas a agendamentos. Ele diz O QUE o sistema pode fazer,
// mas não COMO.

import 'package:dartz/dartz.dart';
import 'package:plataforma_daniela/core/error/failures.dart';
import 'package:plataforma_daniela/features/appointment/domain/entities/appointment_entity.dart';
import 'package:plataforma_daniela/features/appointment/domain/entities/therapist_config_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<TherapistConfigEntity>>> getTherapists();

  Future<Either<Failure, List<String>>> getAvailableSlots({required String therapistId, required DateTime date});

  Future<Either<Failure, void>> createAppointment({required AppointmentEntity appointment});

  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsForTherapist({required String therapistId, required DateTime date});
}
