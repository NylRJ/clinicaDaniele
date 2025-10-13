// ARQUIVO: lib/features/appointment/data/repositories/appointment_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:plataforma_daniela/core/error/exceptions.dart';
import 'package:plataforma_daniela/core/error/failures.dart';
import 'package:plataforma_daniela/features/appointment/data/datasources/appointment_firebase_datasource.dart';
import 'package:plataforma_daniela/features/appointment/data/models/appointment_model.dart';
import 'package:plataforma_daniela/features/appointment/domain/entities/appointment_entity.dart';
import 'package:plataforma_daniela/features/appointment/domain/entities/therapist_config_entity.dart';
import 'package:plataforma_daniela/features/appointment/domain/repositories/appointment_repository.dart';

// Esta classe é a implementação do "contrato" definido em AppointmentRepository.
// Ela é a ponte entre a lógica de negócio (domínio) e a fonte de dados (Firebase).
class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentFirebaseDataSource appointmentFirebaseDataSource;

  AppointmentRepositoryImpl({required this.appointmentFirebaseDataSource});

  // Função para criar um novo agendamento.
  @override
  Future<Either<Failure, void>> createAppointment({required AppointmentEntity appointment}) async {
    try {
      // Converte a entidade (objeto de negócio) para um modelo (objeto de dados).
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
      // Chama a fonte de dados para salvar no Firestore.
      await appointmentFirebaseDataSource.createAppointment(appointment: appointmentModel);
      // Retorna sucesso (Right).
      return const Right(null);
    } on ServerException {
      // Se a fonte de dados lançar um erro, ele é capturado e transformado em uma "Falha".
      return Left(const ServerFailure(message: 'Ocorreu um erro ao criar o agendamento.'));
    }
  }

  // Função para buscar os horários disponíveis.
  @override
  Future<Either<Failure, List<String>>> getAvailableSlots({required String therapistId, required DateTime date}) async {
    try {
      // 1. Busca a configuração do terapeuta (horários de trabalho).
      final therapists = await appointmentFirebaseDataSource.getTherapists();
      final therapistConfig = therapists.firstWhere((t) => t.therapistId == therapistId);

      // 2. Busca os agendamentos já existentes para o dia.
      final bookedAppointments = await appointmentFirebaseDataSource.getBookedAppointments(therapistId: therapistId, date: date);
      final bookedSlots = bookedAppointments.map((e) => '${e.startTime.hour.toString().padLeft(2, '0')}:${e.startTime.minute.toString().padLeft(2, '0')}').toSet();

      // 3. Determina o dia da semana para buscar na disponibilidade.
      final dayOfWeek = _getDayOfWeek(date.weekday);
      final workingSlots = therapistConfig.weeklyAvailability[dayOfWeek] ?? [];

      // 4. Filtra os horários de trabalho, removendo os que já estão ocupados.
      final availableSlots = workingSlots.where((slot) => !bookedSlots.contains(slot)).toList();

      return Right(availableSlots);
    } on ServerException {
      return Left(const ServerFailure(message: 'Não foi possível buscar os horários.'));
    } catch (e) {
      // Captura outros erros (ex: terapeuta não encontrado) e retorna uma falha.
      return Left(const ServerFailure(message: 'Configuração do terapeuta não encontrada.'));
    }
  }

  // Função para buscar a lista de todos os terapeutas.
  @override
  Future<Either<Failure, List<TherapistConfigEntity>>> getTherapists() async {
    try {
      final therapists = await appointmentFirebaseDataSource.getTherapists();
      return Right(therapists);
    } on ServerException {
      return Left(const ServerFailure(message: 'Não foi possível buscar os terapeutas.'));
    }
  }

  // Função para buscar os agendamentos de um terapeuta específico em uma data.
  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsForTherapist({required String therapistId, required DateTime date}) async {
    try {
      final appointments = await appointmentFirebaseDataSource.getBookedAppointments(therapistId: therapistId, date: date);
      return Right(appointments);
    } on ServerException {
      return Left(const ServerFailure(message: 'Não foi possível buscar os agendamentos.'));
    }
  }

  // Função auxiliar para converter o número do dia da semana (1-7) para o nome em inglês usado no Firestore.
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
