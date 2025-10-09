// ARQUIVO: lib/features/appointment/domain/entities/appointment_entity.dart

import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String patientId;
  final String patientName;
  final String therapistId;
  final String therapistName;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  const AppointmentEntity({required this.id, required this.patientId, required this.patientName, required this.therapistId, required this.therapistName, required this.startTime, required this.endTime, required this.status});

  @override
  List<Object?> get props => [id, patientId, therapistId, startTime];
}
