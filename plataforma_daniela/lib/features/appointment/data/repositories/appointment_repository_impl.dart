// ARQUIVO: lib/features/appointment/data/repositories/appointment_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart'; // Import necessário para DateFormat
import 'package:plataforma_daniela/core/error/exceptions.dart';
import 'package:plataforma_daniela/core/error/failures.dart';
import 'package:plataforma_daniela/features/appointment/data/datasources/appointment_firebase_datasource.dart';
import 'package:plataforma_daniela/features/appointment/data/models/appointment_model.dart';
import 'package:plataforma_daniela/features/appointment/domain/entities/appointment_entity.dart';
import 'package:plataforma_daniela/features/appointment/domain/entities/therapist_config_entity.dart';
import 'package:plataforma_daniela/features/appointment/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentFirebaseDataSource appointmentFirebaseDataSource;

  AppointmentRepositoryImpl({required this.appointmentFirebaseDataSource});

  @override
  Future<Either<Failure, void>> createAppointment({required AppointmentEntity appointment}) async {
    try {
      final appointmentModel = AppointmentModel(
        id: appointment.id,
        patientId: appointment.patientId,
        patientName: appointment.patientName,
        therapistId: appointment.therapistId,
        therapistName: appointment.therapistName,
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        status: appointment.status,
      );
      await appointmentFirebaseDataSource.createAppointment(appointment: appointmentModel);
      return const Right(null);
    } on ServerException {
      return Left(const ServerFailure(message: 'Ocorreu um erro ao criar o agendamento.'));
    }
  }

  // <-- MÉTODO ALTERADO PARA USAR STREAM -->
  @override
  Stream<Either<Failure, List<String>>> getAvailableSlots({required String therapistId, required DateTime date}) {
    try {
      // 1. Busca a configuração do terapeuta (isso continua sendo uma busca única).
      final therapistConfigFuture = appointmentFirebaseDataSource.getTherapists();

      // 2. Ouve a stream de agendamentos ocupados em tempo real.
      return appointmentFirebaseDataSource
          .getBookedAppointmentsStream(therapistId: therapistId, date: date)
          .asyncMap((bookedAppointments) async {
            try {
              // 3. Resolve a busca pela configuração do terapeuta.
              final therapists = await therapistConfigFuture;
              final therapistConfig = therapists.firstWhere((t) => t.therapistId == therapistId);

              // 4. Mapeia os horários já ocupados para um formato simples (ex: "10:00").
              final bookedSlots = bookedAppointments.map((e) => DateFormat('HH:mm').format(e.startTime)).toSet();

              // 5. Determina o dia da semana para buscar os horários de trabalho.
              final dayOfWeek = _getDayOfWeek(date.weekday);
              final workingSlots = therapistConfig.weeklyAvailability[dayOfWeek] ?? [];

              // 6. Filtra os horários de trabalho, removendo os que já estão ocupados.
              final availableSlots = workingSlots.where((slot) => !bookedSlots.contains(slot)).toList();

              // 7. Retorna a lista de horários disponíveis.
              return Right<Failure, List<String>>(availableSlots);
            } catch (e) {
              // Captura erros como "terapeuta não encontrado".
              return Left<Failure, List<String>>(const ServerFailure(message: 'Configuração do terapeuta não encontrada.'));
            }
          })
          .handleError((error) {
            // Trata erros que possam ocorrer na stream (ex: falha de permissão).
            return Left<Failure, List<String>>(const ServerFailure(message: 'Não foi possível buscar os horários.'));
          });
    } catch (e) {
      // Captura erros na chamada inicial e retorna uma stream com um único erro.
      return Stream.value(Left(const ServerFailure(message: 'Erro ao iniciar a busca por horários.')));
    }
  }

  @override
  Future<Either<Failure, List<TherapistConfigEntity>>> getTherapists() async {
    try {
      final therapists = await appointmentFirebaseDataSource.getTherapists();
      return Right(therapists);
    } on ServerException {
      return Left(const ServerFailure(message: 'Não foi possível buscar os terapeutas.'));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsForTherapist({required String therapistId, required DateTime date}) async {
    try {
      final appointments = await appointmentFirebaseDataSource.getBookedAppointments(therapistId: therapistId, date: date);
      return Right(appointments);
    } on ServerException {
      return Left(const ServerFailure(message: 'Não foi possível buscar os agendamentos.'));
    }
  }

  @override
  Stream<Either<Failure, List<AppointmentEntity>>> watchAppointmentsForPatient(String patientId) {
    try {
      return appointmentFirebaseDataSource
          .getAppointmentsForPatient(patientId)
          .map((appointments) {
            return Right<Failure, List<AppointmentEntity>>(appointments);
          })
          .handleError((error) {
            print("Erro na stream de agendamentos do paciente: $error");
            return Left<Failure, List<AppointmentEntity>>(const ServerFailure(message: 'Não foi possível buscar seus agendamentos.'));
          });
    } catch (e) {
      return Stream.value(Left<Failure, List<AppointmentEntity>>(ServerFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(String appointmentId) async {
    try {
      await appointmentFirebaseDataSource.deleteAppointment(appointmentId);
      return const Right(null);
    } on ServerException {
      return Left(const ServerFailure(message: 'Ocorreu um erro ao cancelar o agendamento.'));
    }
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return '';
    }
  }
}
