// ARQUIVO: lib/features/appointment/presentation/cubit/appointment_cubit.dart

import 'dart:async'; // Necessário para usar StreamSubscription
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository repository;

  // Variáveis para gerenciar as "escutas" em tempo real.
  StreamSubscription? _patientAppointmentsSubscription;
  StreamSubscription? _availableSlotsSubscription; // <-- ALTERAÇÃO 1: Adicionada

  AppointmentCubit({required this.repository}) : super(const AppointmentInitial());

  Future<void> fetchTherapists() async {
    emit(const AppointmentLoading());
    final result = await repository.getTherapists();
    result.fold((failure) => emit(AppointmentError(message: failure.message)), (therapists) => emit(TherapistsLoaded(therapists)));
  }

  // <-- ALTERAÇÃO 2: Método completamente modificado para usar Stream
  void fetchAvailableSlots({required String therapistId, required DateTime date}) {
    emit(const AvailableSlotsLoading());
    _availableSlotsSubscription?.cancel(); // Cancela a "escuta" anterior para evitar sobreposição.
    _availableSlotsSubscription = repository.getAvailableSlots(therapistId: therapistId, date: date).listen((result) {
      // .listen() inicia a "escuta" da stream.
      result.fold((failure) => emit(AppointmentError(message: failure.message)), (slots) => emit(AvailableSlotsLoaded(slots)));
    });
  }

  Future<void> submitAppointment({required AppointmentEntity appointment}) async {
    emit(const AppointmentLoading());
    final result = await repository.createAppointment(appointment: appointment);
    result.fold((failure) => emit(AppointmentError(message: failure.message)), (_) => emit(const AppointmentCreated()));
  }

  void watchPatientAppointments(String patientId) {
    _patientAppointmentsSubscription?.cancel();
    _patientAppointmentsSubscription = repository.watchAppointmentsForPatient(patientId).listen((result) {
      result.fold((failure) => emit(AppointmentError(message: failure.message)), (appointments) => emit(PatientAppointmentsLoaded(appointments)));
    });
  }

  Future<void> cancelAppointment(String appointmentId) async {
    final result = await repository.cancelAppointment(appointmentId);
    result.fold((failure) => emit(AppointmentError(message: failure.message)), (_) {
      // Não emite estado aqui, o listener de watchPatientAppointments fará isso.
    });
  }

  // <-- ALTERAÇÃO 3: Garante que todas as "escutas" sejam encerradas.
  @override
  Future<void> close() {
    _patientAppointmentsSubscription?.cancel();
    _availableSlotsSubscription?.cancel(); // Encerra a nova escuta.
    return super.close();
  }
}
