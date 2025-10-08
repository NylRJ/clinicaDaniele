/**
 * // ARQUIVO: lib/features/appointment/presentation/cubit/appointment_cubit.dart
 *
 * // OBJETIVO: Gerenciar o estado da tela de agendamento.
 *
 * // REQUISITOS:
 * // - Classe `AppointmentCubit` que estende `Cubit<AppointmentState>`.
 * // - Dependência do `AppointmentRepository`.
 * // - Métodos:
 * //   - `fetchTherapists()`: Chama o repositório e emite `TherapistsLoaded` ou `AppointmentError`.
 * //   - `fetchAvailableSlots({required String therapistId, required DateTime date})`: Chama o repositório e emite `AvailableSlotsLoaded` ou `AppointmentError`.
 * //   - `submitAppointment(...)`: Monta o `AppointmentEntity` e chama o repositório, emitindo `AppointmentCreated` ou `AppointmentError`.
 *
 * // INSTRUÇÕES PARA A IA:
 * // Gere a classe `AppointmentCubit` abaixo.
 */

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../appointment/domain/entities/appointment_entity.dart';
import '../../../appointment/domain/repositories/appointment_repository.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository repository;

  AppointmentCubit({required this.repository}) : super(const AppointmentInitial());

  Future<void> fetchTherapists() async {
    emit(const AppointmentLoading());
    final result = await repository.getTherapists();
    result.fold(
      (l) => emit(AppointmentError(l.message)),
      (therapists) => emit(TherapistsLoaded(therapists)),
    );
  }

  Future<void> fetchAvailableSlots({
    required String therapistId,
    required DateTime date,
  }) async {
    emit(const AppointmentLoading());
    final result = await repository.getAvailableSlots(therapistId: therapistId, date: date);
    result.fold(
      (l) => emit(AppointmentError(l.message)),
      (slots) => emit(AvailableSlotsLoaded(slots)),
    );
  }

  Future<void> submitAppointment({
    required String patientId,
    required String patientName,
    required String therapistId,
    required String therapistName,
    required DateTime date,
    required String timeSlot, // formato 'HH:mm'
  }) async {
    emit(const AppointmentLoading());
    try {
      final start = _mergeDateAndTime(date, timeSlot);
      final end = start.add(const Duration(minutes: 50));

      final entity = AppointmentEntity(
        id: '',
        patientId: patientId,
        patientName: patientName,
        therapistId: therapistId,
        therapistName: therapistName,
        startTime: start,
        endTime: end,
        status: 'agendado',
      );

      final res = await repository.createAppointment(appointment: entity);
      res.fold(
        (l) => emit(AppointmentError(l.message)),
        (_) => emit(const AppointmentCreated()),
      );
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  DateTime _mergeDateAndTime(DateTime date, String hhmm) {
    final parts = hhmm.split(':');
    final h = int.tryParse(parts.elementAt(0)) ?? 0;
    final m = int.tryParse(parts.elementAt(1)) ?? 0;
    return DateTime(date.year, date.month, date.day, h, m);
  }
}

