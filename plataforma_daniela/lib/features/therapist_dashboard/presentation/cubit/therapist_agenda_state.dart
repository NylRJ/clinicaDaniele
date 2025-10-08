/**
 * // ARQUIVO: lib/features/therapist_dashboard/presentation/cubit/therapist_agenda_state.dart
 *
 * // OBJETIVO: Definir os estados da UI para a agenda do terapeuta.
 *
 * // REQUISITOS:
 * // - Classe abstrata `TherapistAgendaState` com Equatable.
 * // - Estados concretos:
 * //   - `TherapistAgendaInitial`: Estado inicial.
 * //   - `TherapistAgendaLoading`: Carregando os agendamentos.
 * //   - `TherapistAgendaLoaded`: Agendamentos carregados com sucesso. Deve conter `final List<AppointmentEntity> appointments`.
 * //   - `TherapistAgendaError`: Erro ao carregar. Deve conter `final String message`.
 *
 * // INSTRUÇÕES PARA A IA: Gere o código para os estados abaixo.
 */

import 'package:equatable/equatable.dart';

import '../../../appointment/domain/entities/appointment_entity.dart';

abstract class TherapistAgendaState extends Equatable {
  const TherapistAgendaState();
  @override
  List<Object?> get props => [];
}

class TherapistAgendaInitial extends TherapistAgendaState {
  const TherapistAgendaInitial();
}

class TherapistAgendaLoading extends TherapistAgendaState {
  const TherapistAgendaLoading();
}

class TherapistAgendaLoaded extends TherapistAgendaState {
  final List<AppointmentEntity> appointments;
  const TherapistAgendaLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class TherapistAgendaError extends TherapistAgendaState {
  final String message;
  const TherapistAgendaError(this.message);

  @override
  List<Object?> get props => [message];
}

