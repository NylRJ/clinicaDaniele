import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/therapist_config_entity.dart';

final class TherapistConfigModel extends TherapistConfigEntity {
  const TherapistConfigModel({required super.therapistId, required super.therapistName, required super.sessionDurationMinutes, required super.weeklyAvailability});

  factory TherapistConfigModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>? ?? {};
    final availabilityRaw = (data['weeklyAvailability'] as Map<String, dynamic>?) ?? {};

    final weeklyAvailability = availabilityRaw.map((key, value) {
      final list = (value as List?)?.map((e) => e.toString()).toList() ?? <String>[];
      return MapEntry(key.toString(), list);
    });

    // Accept either a bare UID or a document path like '/users/<uid>'
    String rawId = (data['therapistId'] ?? snap.id).toString();
    if (rawId.contains('/')) {
      final parts = rawId.split('/');
      rawId = parts.isNotEmpty ? parts.last : rawId;
    }

    return TherapistConfigModel(
      therapistId: rawId,
      therapistName: (data['therapistName'] ?? '').toString(),
      sessionDurationMinutes: (data['sessionDurationMinutes'] is int) ? data['sessionDurationMinutes'] as int : int.tryParse(data['sessionDurationMinutes']?.toString() ?? '') ?? 50,
      weeklyAvailability: weeklyAvailability,
    );
  }

  Map<String, dynamic> toJson() {
    return {'therapistId': therapistId, 'therapistName': therapistName, 'sessionDurationMinutes': sessionDurationMinutes, 'weeklyAvailability': weeklyAvailability};
  }
}
