// ARQUIVO: lib/features/appointment/domain/entities/therapist_config_entity.dart
//
// OBJETIVO: Este ficheiro define o "molde" para um objeto de configuração
// do terapeuta, incluindo os seus horários e dados básicos.

import 'package:equatable/equatable.dart';

class TherapistConfigEntity extends Equatable {
  final String therapistId;
  final String therapistName;
  final int sessionDurationMinutes;
  final Map<String, List<String>> weeklyAvailability;

  const TherapistConfigEntity({required this.therapistId, required this.therapistName, required this.sessionDurationMinutes, required this.weeklyAvailability});

  @override
  List<Object?> get props => [therapistId, therapistName, sessionDurationMinutes, weeklyAvailability];
}
