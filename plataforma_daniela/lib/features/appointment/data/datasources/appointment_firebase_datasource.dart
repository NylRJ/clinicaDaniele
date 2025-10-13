/**
 * // ARQUIVO: lib/features/appointment/data/datasources/appointment_firebase_datasource.dart
 *
 * // OBJETIVO: Implementar a comunicação direta com o Firestore para a lógica de agendamento.
 *
 * // CORREÇÕES APLICADAS:
 * // - Adicionados logs de depuração detalhados para rastrear o fluxo.
 * // - O bloco `catch` agora imprime o erro específico, revelando a causa raiz.
 */

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';
import '../models/therapist_config_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class AppointmentFirebaseDataSource {
  Future<List<TherapistConfigModel>> getTherapists();

  Future<List<AppointmentModel>> getBookedAppointments({required String therapistId, required DateTime date});

  Future<void> createAppointment({required AppointmentModel appointment});
}

class AppointmentFirebaseDataSourceImpl implements AppointmentFirebaseDataSource {
  final FirebaseFirestore firestore;

  AppointmentFirebaseDataSourceImpl(this.firestore);

  @override
  Future<List<TherapistConfigModel>> getTherapists() async {
    try {
      // Log para indicar que a função começou.
      print("[DataSource] Buscando terapeutas na coleção 'terapeutas_config'...");

      final snap = await firestore.collection('terapeutas_config').get();

      // Log para mostrar quantos documentos foram encontrados.
      print("[DataSource] Encontrados ${snap.docs.length} documentos de configuração de terapeutas.");

      if (snap.docs.isEmpty) {
        print("[DataSource] AVISO: A coleção 'terapeutas_config' está vazia ou não foi encontrada. Verifique o nome da coleção no Firebase.");
      }

      final therapists = snap.docs.map((d) {
        print("[DataSource] Processando documento com ID: ${d.id}");
        return TherapistConfigModel.fromSnapshot(d);
      }).toList();

      print("[DataSource] Mapeamento de terapeutas concluído com sucesso.");
      return therapists;
    } catch (e) {
      // Log CRÍTICO: Imprime o erro exato que o Firebase retornou.
      print("########## ERRO FATAL AO BUSCAR TERAPEUTAS ##########");
      print("Erro: $e");
      print("###################################################");

      // Lança uma exceção para que a camada superior possa tratar.
      throw ServerException(message: 'Falha ao buscar dados dos terapeutas.');
    }
  }

  @override
  Future<List<AppointmentModel>> getBookedAppointments({required String therapistId, required DateTime date}) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      print("[DataSource] Buscando agendamentos para o terapeuta $therapistId no dia $startOfDay");

      final q = await firestore
          .collection('agendas')
          .where('therapistId', isEqualTo: therapistId)
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('startTime', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      print("[DataSource] Encontrados ${q.docs.length} agendamentos para esta data.");
      return q.docs.map((d) => AppointmentModel.fromSnapshot(d)).toList();
    } catch (e) {
      print("########## ERRO AO BUSCAR AGENDAMENTOS ##########");
      print("Erro: $e");
      print("###################################################");
      throw ServerException();
    }
  }

  @override
  Future<void> createAppointment({required AppointmentModel appointment}) async {
    try {
      print("[DataSource] Criando novo agendamento...");
      if (appointment.id.isEmpty) {
        await firestore.collection('agendas').add(appointment.toJson());
      } else {
        final ref = firestore.collection('agendas').doc(appointment.id);
        await ref.set(appointment.toJson());
      }
      print("[DataSource] Agendamento criado com sucesso.");
    } catch (e) {
      print("########## ERRO AO CRIAR AGENDAMENTO ##########");
      print("Erro: $e");
      print("###################################################");
      throw ServerException();
    }
  }
}
