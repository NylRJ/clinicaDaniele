// ARQUIVO: lib/features/therapist_dashboard/presentation/screens/therapist_agenda_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/therapist_agenda_cubit.dart';
import '../cubit/therapist_agenda_state.dart';

class TherapistAgendaScreen extends StatefulWidget {
  // O construtor é simples, sem parâmetros.
  const TherapistAgendaScreen({Key? key}) : super(key: key);

  @override
  State<TherapistAgendaScreen> createState() => _TherapistAgendaScreenState();
}

class _TherapistAgendaScreenState extends State<TherapistAgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAppointmentsForSelectedDay();
  }

  void _fetchAppointmentsForSelectedDay() {
    // Busca o ID do terapeuta logado a partir do AuthCubit.
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      final therapistId = authState.user.uid;
      context.read<TherapistAgendaCubit>().fetchAppointments(therapistId: therapistId, date: _selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Chama o método de logout do AuthCubit
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<TherapistAgendaCubit, TherapistAgendaState>(
              builder: (context, state) {
                if (state is TherapistAgendaLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TherapistAgendaError) {
                  return Center(child: Text('Erro: ${state.message}'));
                }
                if (state is TherapistAgendaLoaded) {
                  if (state.appointments.isEmpty) {
                    return const Center(child: Text('Nenhum agendamento para este dia.'));
                  }
                  return _buildAppointmentsList(state.appointments);
                }
                return const Center(child: Text('Selecione um dia para ver os agendamentos.'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.week,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        _fetchAppointmentsForSelectedDay();
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  Widget _buildAppointmentsList(List appointments) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('Paciente: ${appointment.patientName}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Horário: ${DateFormat('HH:mm').format(appointment.startTime)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Futuramente, pode navegar para uma tela de detalhes da consulta.
            },
          ),
        );
      },
    );
  }
}
