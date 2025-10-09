// ARQUIVO: lib/features/appointment/presentation/cubit/appointment_state.dart

import 'package:equatable/equatable.dart';
// Corrigido para importar a ENTIDADE em vez do MODELO
import 'package:plataforma_daniela/features/appointment/domain/entities/therapist_config_entity.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();
  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

// Novo estado para o carregamento apenas dos horários
class AvailableSlotsLoading extends AppointmentState {
  const AvailableSlotsLoading();
}

class TherapistsLoaded extends AppointmentState {
  // Corrigido para usar a ENTIDADE
  final List<TherapistConfigEntity> therapists;
  const TherapistsLoaded(this.therapists);

  @override
  List<Object?> get props => [therapists];
}

class AvailableSlotsLoaded extends AppointmentState {
  final List<String> slots;
  const AvailableSlotsLoaded(this.slots);

  @override
  List<Object?> get props => [slots];
}

class AppointmentCreated extends AppointmentState {
  const AppointmentCreated();
}

class AppointmentError extends AppointmentState {
  final String message;
  const AppointmentError({required this.message});

  @override
  List<Object?> get props => [message];
}
