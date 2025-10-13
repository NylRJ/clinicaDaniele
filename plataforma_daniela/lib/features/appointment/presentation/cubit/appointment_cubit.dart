// ARQUIVO: lib/features/appointment/presentation/cubit/appointment_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment_entity.dart'; // <-- IMPORTA A ENTIDADE
import '../../domain/repositories/appointment_repository.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository repository;

  AppointmentCubit({required this.repository}) : super(const AppointmentInitial());

  Future<void> fetchTherapists() async {
    // 1. Emite o estado de carregamento
    emit(const AppointmentLoading());

    // 2. Chama o repositório
    final result = await repository.getTherapists();

    // 3. Emite sucesso ou erro com base no resultado
    result.fold((failure) => emit(AppointmentError(message: failure.message)), (therapists) => emit(TherapistsLoaded(therapists)));
  }

  Future<void> fetchAvailableSlots({required String therapistId, required DateTime date}) async {
    emit(const AvailableSlotsLoading());
    final result = await repository.getAvailableSlots(therapistId: therapistId, date: date);
    result.fold((failure) => emit(AppointmentError(message: failure.message)), (slots) => emit(AvailableSlotsLoaded(slots)));
  }

  // O método agora espera receber a entidade completa, corrigindo o erro
  Future<void> submitAppointment({required AppointmentEntity appointment}) async {
    emit(const AppointmentLoading());
    final result = await repository.createAppointment(appointment: appointment);
    result.fold((failure) => emit(AppointmentError(message: failure.message)), (_) => emit(const AppointmentCreated()));
  }
}
