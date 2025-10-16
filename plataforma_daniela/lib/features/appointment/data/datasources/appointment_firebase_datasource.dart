// ARQUIVO: lib/features/appointment/data/datasources/appointment_firebase_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';
import '../models/therapist_config_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class AppointmentFirebaseDataSource {
  Future<List<TherapistConfigModel>> getTherapists();
  Future<List<AppointmentModel>> getBookedAppointments({required String therapistId, required DateTime date});
  Future<void> createAppointment({required AppointmentModel appointment});

  // Métodos novos para o listener
  Stream<List<AppointmentModel>> getAppointmentsForPatient(String patientId);
  Future<void> deleteAppointment(String appointmentId);
  Stream<List<AppointmentModel>> getBookedAppointmentsStream({required String therapistId, required DateTime date});
}

class AppointmentFirebaseDataSourceImpl implements AppointmentFirebaseDataSource {
  final FirebaseFirestore firestore;

  AppointmentFirebaseDataSourceImpl(this.firestore);

  @override
  Future<List<TherapistConfigModel>> getTherapists() async {
    try {
      print("[DataSource] Buscando terapeutas na coleção 'terapeutas_config'...");
      final snap = await firestore.collection('terapeutas_config').get();
      print("[DataSource] Encontrados ${snap.docs.length} documentos de configuração de terapeutas.");
      if (snap.docs.isEmpty) {
        print("[DataSource] AVISO: A coleção 'terapeutas_config' está vazia ou não foi encontrada.");
      }
      final therapists = snap.docs.map((d) => TherapistConfigModel.fromSnapshot(d)).toList();
      print("[DataSource] Mapeamento de terapeutas concluído com sucesso.");
      return therapists;
    } catch (e) {
      print("########## ERRO FATAL AO BUSCAR TERAPEUTAS ##########");
      print("Erro: $e");
      print("###################################################");
      throw ServerException(message: 'Falha ao buscar dados dos terapeutas.');
    }
  }

  // Este método agora é usado apenas pela tela do Terapeuta (provavelmente)
  @override
  Future<List<AppointmentModel>> getBookedAppointments({required String therapistId, required DateTime date}) async {
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
    } catch (e) {
      print("########## ERRO AO BUSCAR AGENDAMENTOS (GET) ##########");
      print("Erro: $e");
      print("###################################################");
      throw ServerException();
    }
  }

  // Novo método com Stream
  @override
  Stream<List<AppointmentModel>> getBookedAppointmentsStream({required String therapistId, required DateTime date}) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return firestore
        .collection('agendas')
        .where('therapistId', isEqualTo: therapistId)
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThan: Timestamp.fromDate(endOfDay))
        .snapshots() // <-- A MÁGICA DO TEMPO REAL ACONTECE AQUI
        .map((snapshot) => snapshot.docs.map((d) => AppointmentModel.fromSnapshot(d)).toList());
  }

  @override
  Future<void> createAppointment({required AppointmentModel appointment}) async {
    try {
      await firestore.collection('agendas').add(appointment.toJson());
    } catch (e) {
      print("########## ERRO AO CRIAR AGENDAMENTO ##########");
      print("Erro: $e");
      print("###################################################");
      throw ServerException();
    }
  }

  @override
  Stream<List<AppointmentModel>> getAppointmentsForPatient(String patientId) {
    try {
      print("[DataSource] Observando agendamentos para o paciente $patientId");
      return firestore
          .collection('agendas')
          .where('patientId', isEqualTo: patientId)
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('startTime')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => AppointmentModel.fromSnapshot(doc)).toList());
    } catch (e) {
      print("########## ERRO AO OBSERVAR AGENDAMENTOS DO PACIENTE ##########");
      print("Erro: $e");
      print("###################################################");
      return Stream.error(ServerException());
    }
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      print("[DataSource] Deletando agendamento com ID: $appointmentId");
      await firestore.collection('agendas').doc(appointmentId).delete();
      print("[DataSource] Agendamento deletado com sucesso.");
    } catch (e) {
      print("########## ERRO AO DELETAR AGENDAMENTO ##########");
      print("Erro: $e");
      print("###################################################");
      throw ServerException();
    }
  }
}
