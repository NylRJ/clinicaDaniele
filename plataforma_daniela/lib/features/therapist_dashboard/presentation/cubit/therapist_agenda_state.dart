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
