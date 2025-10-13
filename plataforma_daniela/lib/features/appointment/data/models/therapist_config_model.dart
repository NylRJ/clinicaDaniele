// ARQUIVO: lib/features/appointment/data/models/therapist_config_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/therapist_config_entity.dart';

final class TherapistConfigModel extends TherapistConfigEntity {
  const TherapistConfigModel({required super.therapistId, required super.therapistName, required super.sessionDurationMinutes, required super.weeklyAvailability});

  // FÁBRICA SIMPLIFICADA
  factory TherapistConfigModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>? ?? {};
    final availabilityRaw = (data['weeklyAvailability'] as Map<String, dynamic>?) ?? {};

    final weeklyAvailability = availabilityRaw.map((key, value) {
      final list = (value as List?)?.map((e) => e.toString()).toList() ?? <String>[];
      return MapEntry(key.toString(), list);
    });

    return TherapistConfigModel(
      // Agora ele lê o therapistId diretamente ou usa o ID do documento
      therapistId: (data['therapistId'] ?? snap.id).toString(),
      therapistName: (data['therapistName'] ?? '').toString(),
      sessionDurationMinutes: (data['sessionDurationMinutes'] as int?) ?? 50,
      weeklyAvailability: weeklyAvailability,
    );
  }

  Map<String, dynamic> toJson() {
    return {'therapistId': therapistId, 'therapistName': therapistName, 'sessionDurationMinutes': sessionDurationMinutes, 'weeklyAvailability': weeklyAvailability};
  }
}
