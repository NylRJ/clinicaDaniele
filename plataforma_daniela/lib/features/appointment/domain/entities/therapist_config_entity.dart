import 'package:equatable/equatable.dart';

// Remova a palavra 'abstract' se ela existir.
class TherapistConfigEntity extends Equatable {
  final String therapistId;
  final String therapistName;
  final int sessionDurationMinutes;
  final Map<String, List<String>> weeklyAvailability;

  const TherapistConfigEntity({required this.therapistId, required this.therapistName, required this.sessionDurationMinutes, required this.weeklyAvailability});

  @override
  List<Object?> get props => [therapistId, therapistName];
}
