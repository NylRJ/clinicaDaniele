/**
 * // ARQUIVO: lib/features/appointment/data/datasources/appointment_firebase_datasource.dart
 *
 * // OBJETIVO: Implementar a comunicação direta com o Firestore para a lógica de agendamento.
 *
 * // REQUISITOS:
 * // - Classe abstrata `AppointmentFirebaseDataSource`.
 * // - Implementação `AppointmentFirebaseDataSourceImpl` com dependência do `FirebaseFirestore`.
 * // - Métodos:
 * //   - `Future<List<TherapistConfigModel>> getTherapists()`: Busca todos os documentos da coleção 'terapeutas_config'.
 * //   - `Future<List<AppointmentModel>> getBookedAppointments({required String therapistId, required DateTime date})`: Busca os agendamentos já existentes para um terapeuta em um dia específico.
 * //   - `Future<void> createAppointment({required AppointmentModel appointment})`: Cria um novo documento na coleção 'agendas'.
 *
 * // INSTRUÇÕES PARA A IA:
 * // Gere as classes abaixo.
 */

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';
import '../models/therapist_config_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class AppointmentFirebaseDataSource {
  Future<List<TherapistConfigModel>> getTherapists();

  Future<List<AppointmentModel>> getBookedAppointments({
    required String therapistId,
    required DateTime date,
  });

  Future<void> createAppointment({required AppointmentModel appointment});
}

class AppointmentFirebaseDataSourceImpl implements AppointmentFirebaseDataSource {
  final FirebaseFirestore firestore;

  AppointmentFirebaseDataSourceImpl(this.firestore);

  @override
  Future<List<TherapistConfigModel>> getTherapists() async {
    try {
      final snap = await firestore.collection('terapeutas_config').get();
      return snap.docs.map((d) => TherapistConfigModel.fromSnapshot(d)).toList();
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<AppointmentModel>> getBookedAppointments({
    required String therapistId,
    required DateTime date,
  }) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final q = await firestore
          .collection('agendas')
          .where('therapistId', isEqualTo: therapistId)
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('startTime', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return q.docs.map((d) => AppointmentModel.fromSnapshot(d)).toList();
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> createAppointment({required AppointmentModel appointment}) async {
    try {
      if (appointment.id.isEmpty) {
        await firestore.collection('agendas').add(appointment.toJson());
      } else {
        final ref = firestore.collection('agendas').doc(appointment.id);
        await ref.set(appointment.toJson());
      }
    } catch (_) {
      throw ServerException();
    }
  }
}
