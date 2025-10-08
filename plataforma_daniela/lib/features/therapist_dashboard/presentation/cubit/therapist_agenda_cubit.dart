/**
 * // ARQUIVO: lib/features/therapist_dashboard/presentation/cubit/therapist_agenda_cubit.dart
 *
 * // OBJETIVO: Gerenciar o estado da tela da agenda do terapeuta.
 *
 * // REQUISITOS:
 * // - Classe `TherapistAgendaCubit` que estende `Cubit<TherapistAgendaState>`.
 * // - Dependência do `AppointmentRepository`.
 * // - Método `fetchAppointments({required String therapistId, required DateTime date})`:
 * //   - Emite `TherapistAgendaLoading`.
 * //   - Chama `getAppointmentsForTherapist` do repositório.
 * //   - Emite `TherapistAgendaLoaded` em caso de sucesso ou `TherapistAgendaError` em caso de falha.
 *
 * // INSTRUÇÕES PARA A IA: Gere a classe TherapistAgendaCubit.
 */

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../appointment/domain/repositories/appointment_repository.dart';
import 'therapist_agenda_state.dart';

class TherapistAgendaCubit extends Cubit<TherapistAgendaState> {
  final AppointmentRepository repository;
  TherapistAgendaCubit({required this.repository}) : super(const TherapistAgendaInitial());

  Future<void> fetchAppointments({
    required String therapistId,
    required DateTime date,
  }) async {
    emit(const TherapistAgendaLoading());
    final res = await repository.getAppointmentsForTherapist(
      therapistId: therapistId,
      date: date,
    );
    res.fold(
      (l) => emit(TherapistAgendaError(l.message)),
      (appointments) => emit(TherapistAgendaLoaded(appointments)),
    );
  }
}

