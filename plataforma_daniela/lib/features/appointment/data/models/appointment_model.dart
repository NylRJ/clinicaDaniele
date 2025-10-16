import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/appointment_entity.dart';

final class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({required super.id, required super.patientId, required super.patientName, required super.therapistId, required super.therapistName, required super.startTime, required super.endTime, required super.status});

  factory AppointmentModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>? ?? {};

    DateTime _toDate(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      final parsed = DateTime.tryParse(v?.toString() ?? '');
      return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
    }

    return AppointmentModel(
      id: (data['id'] ?? snap.id).toString(),
      patientId: (data['patientId'] ?? '').toString(),
      patientName: (data['patientName'] ?? '').toString(),
      therapistId: (data['therapistId'] ?? '').toString(),
      therapistName: (data['therapistName'] ?? '').toString(),
      startTime: _toDate(data['startTime']),
      endTime: _toDate(data['endTime']),
      status: (data['status'] ?? 'agendado').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    // CORREÇÃO APLICADA AQUI: O 'id' não é mais incluído no JSON.
    // O Firestore irá gerar o ID do documento automaticamente,
    // e o nosso `fromSnapshot` já o lê corretamente.
    return {'patientId': patientId, 'patientName': patientName, 'therapistId': therapistId, 'therapistName': therapistName, 'startTime': Timestamp.fromDate(startTime), 'endTime': Timestamp.fromDate(endTime), 'status': status};
  }
}
