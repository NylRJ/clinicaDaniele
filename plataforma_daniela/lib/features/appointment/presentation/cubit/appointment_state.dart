import 'package:equatable/equatable.dart';
import 'package:plataforma_daniela/features/appointment/data/models/therapist_config_model.dart';

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

class TherapistsLoaded extends AppointmentState {
  final List<TherapistConfigModel> therapists;
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
  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}
