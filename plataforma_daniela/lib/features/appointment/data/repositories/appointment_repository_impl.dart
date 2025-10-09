// ARQUIVO: lib/features/appointment/data/repositories/appointment_repository_impl.dart
import 'package:dartz/dartz.dart';
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

  @override
  Future<Either<Failure, List<String>>> getAvailableSlots({required String therapistId, required DateTime date}) async {
    try {
      // 1. Busca a configuração do terapeuta (incluindo horários de trabalho)
      final therapists = await appointmentFirebaseDataSource.getTherapists();
      final therapistConfig = therapists.firstWhere((t) => t.therapistId == therapistId);

      // 2. Busca os agendamentos já existentes para esse dia
      final bookedAppointments = await appointmentFirebaseDataSource.getBookedAppointments(therapistId: therapistId, date: date);
      final bookedSlots = bookedAppointments.map((e) => '${e.startTime.hour.toString().padLeft(2, '0')}:${e.startTime.minute.toString().padLeft(2, '0')}').toSet();

      // 3. Determina os horários de trabalho para o dia da semana selecionado
      final dayOfWeek = _getDayOfWeek(date.weekday);
      final workingSlots = therapistConfig.weeklyAvailability[dayOfWeek] ?? [];

      // 4. Filtra os horários de trabalho, removendo os que já foram agendados
      final availableSlots = workingSlots.where((slot) => !bookedSlots.contains(slot)).toList();

      return Right(availableSlots);
    } on ServerException {
      return Left(const ServerFailure(message: 'Não foi possível buscar os horários.'));
    } catch (e) {
      // Captura o erro caso o terapeuta não seja encontrado
      return Left(const ServerFailure(message: 'Configuração do terapeuta não encontrada.'));
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
