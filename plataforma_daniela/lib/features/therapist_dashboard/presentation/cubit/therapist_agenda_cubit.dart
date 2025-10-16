import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../appointment/domain/repositories/appointment_repository.dart';
import 'therapist_agenda_state.dart';

class TherapistAgendaCubit extends Cubit<TherapistAgendaState> {
  final AppointmentRepository repository;
  TherapistAgendaCubit({required this.repository}) : super(const TherapistAgendaInitial());

  Future<void> fetchAppointments({required String therapistId, required DateTime date}) async {
    emit(const TherapistAgendaLoading());
    final res = await repository.getAppointmentsForTherapist(therapistId: therapistId, date: date);
    res.fold((l) => emit(TherapistAgendaError(l.message)), (appointments) => emit(TherapistAgendaLoaded(appointments)));
  }
}
