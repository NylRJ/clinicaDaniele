// ARQUIVO: lib/features/booking/presentation/screens/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'package:plataforma_daniela/core/widgets/app_background.dart';
import 'package:plataforma_daniela/features/appointment/domain/entities/appointment_entity.dart';
import 'package:plataforma_daniela/features/appointment/domain/entities/therapist_config_entity.dart';
import 'package:plataforma_daniela/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:plataforma_daniela/features/appointment/presentation/cubit/appointment_state.dart';
import 'package:plataforma_daniela/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plataforma_daniela/features/auth/presentation/cubit/auth_state.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TherapistConfigEntity? _selectedTherapist;
  DateTime _selectedDay = DateTime.now();
  String? _selectedSlot;
  List<TherapistConfigEntity> _therapists = [];

  // Variável para guardar os agendamentos do paciente
  List<AppointmentEntity> _myAppointments = [];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      // Inicia a busca por terapeutas E a observação dos agendamentos do paciente.
      context.read<AppointmentCubit>().fetchTherapists();
      context.read<AppointmentCubit>().watchPatientAppointments(authState.user.uid);
    }
  }

  void _onTherapistChanged(TherapistConfigEntity? therapist) {
    setState(() {
      _selectedTherapist = therapist;
      _selectedSlot = null;
    });
    _fetchSlots();
  }

  void _onDateChanged(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _selectedSlot = null;
    });
    _fetchSlots();
  }

  void _fetchSlots() {
    if (_selectedTherapist != null) {
      context.read<AppointmentCubit>().fetchAvailableSlots(therapistId: _selectedTherapist!.therapistId, date: _selectedDay);
    }
  }

  void _submitAppointment() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated && _selectedTherapist != null && _selectedSlot != null) {
      final patient = authState.user;
      final hour = int.parse(_selectedSlot!.split(':')[0]);
      final minute = int.parse(_selectedSlot!.split(':')[1]);
      final startTime = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, hour, minute);

      final appointment = AppointmentEntity(
        id: '',
        patientId: patient.uid,
        patientName: patient.name,
        therapistId: _selectedTherapist!.therapistId,
        therapistName: _selectedTherapist!.therapistName,
        startTime: startTime,
        endTime: startTime.add(Duration(minutes: _selectedTherapist!.sessionDurationMinutes)),
        status: 'agendado',
      );
      context.read<AppointmentCubit>().submitAppointment(appointment: appointment);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, preencha todos os campos.')));
    }
  }

  // NOVA FUNÇÃO PARA CANCELAR
  void _cancelAppointment(AppointmentEntity appointment) {
    // Regra de negócio: 48 horas de antecedência
    if (appointment.startTime.difference(DateTime.now()).inHours < 48) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cancelamentos devem ser feitos com 48h de antecedência.'), backgroundColor: Colors.orange));
      return;
    }

    // Popup de confirmação
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Cancelamento'),
        content: const Text('Tem certeza que deseja cancelar esta consulta?'),
        actions: [
          TextButton(child: const Text('Não'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Sim, cancelar'),
            onPressed: () {
              context.read<AppointmentCubit>().cancelAppointment(appointment.id);
              // Após cancelar, atualiza a lista de horários disponíveis
              _fetchSlots();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BrandColors.ecru,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return Text('Olá, ${state.user.name}');
              }
              return const Text('Minha Área');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: BrandColors.charcoal),
              onPressed: () {
                context.read<AuthCubit>().signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Novo Agendamento'),
              Tab(text: 'Meus Agendamentos'), // ABA ATUALIZADA
            ],
          ),
        ),
        body: BlocListener<AppointmentCubit, AppointmentState>(
          // Listener genérico para erros e sucesso
          listener: (context, state) {
            if (state is AppointmentError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
            }
            if (state is AppointmentCreated) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Consulta agendada com sucesso!'), backgroundColor: Colors.green));
              setState(() => _selectedSlot = null);
              _fetchSlots(); // Atualiza a grade de horários
            }
          },
          child: TabBarView(
            children: [
              _buildNewAppointmentTab(), // Função renomeada
              _buildMyApointmentsTab(), // NOVA ABA
            ],
          ),
        ),
      ),
    );
  }

  // Função renomeada
  Widget _buildNewAppointmentTab() {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        if (state is TherapistsLoaded) {
          _therapists = state.therapists;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state is AppointmentLoading && _therapists.isEmpty) const Center(child: CircularProgressIndicator()) else _buildTherapistSelector(_therapists),
              const SizedBox(height: 20),
              ListTile(
                title: Text('Data Selecionada: ${DateFormat('dd/MM/yyyy').format(_selectedDay)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(context: context, initialDate: _selectedDay, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
                  if (pickedDate != null) {
                    _onDateChanged(pickedDate, pickedDate);
                  }
                },
              ),
              const SizedBox(height: 20),
              if (state is AvailableSlotsLoading) const Center(child: CircularProgressIndicator()) else if (state is AvailableSlotsLoaded) _buildSlotsGrid(state.slots),
              const SizedBox(height: 40),
              ElevatedButton(onPressed: _selectedSlot != null && state is! AppointmentLoading ? _submitAppointment : null, child: const Text('Confirmar Agendamento')),
            ],
          ),
        );
      },
    );
  }

  // NOVA FUNÇÃO PARA CONSTRUIR A ABA "MEUS AGENDAMENTOS"
  Widget _buildMyApointmentsTab() {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        // Atualiza a lista local quando o estado certo chega do listener
        if (state is PatientAppointmentsLoaded) {
          _myAppointments = state.appointments;
        }

        if (_myAppointments.isEmpty) {
          return const Center(child: Text('Você não possui agendamentos futuros.'));
        }

        return ListView.builder(
          itemCount: _myAppointments.length,
          itemBuilder: (context, index) {
            final appointment = _myAppointments[index];
            final canCancel = appointment.startTime.difference(DateTime.now()).inHours >= 48;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text('Consulta com ${appointment.therapistName}'),
                subtitle: Text(DateFormat('dd/MM/yyyy \'às\' HH:mm').format(appointment.startTime)),
                trailing: Tooltip(
                  message: canCancel ? 'Cancelar agendamento' : 'Cancelamento não permitido (menos de 48h)',
                  child: IconButton(
                    icon: Icon(Icons.cancel, color: canCancel ? Colors.red : Colors.grey),
                    onPressed: canCancel ? () => _cancelAppointment(appointment) : null,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTherapistSelector(List<TherapistConfigEntity> therapists) {
    return DropdownButtonFormField<TherapistConfigEntity>(
      value: _selectedTherapist,
      hint: const Text('Selecione um terapeuta'),
      onChanged: _onTherapistChanged,
      items: therapists.map((therapist) {
        return DropdownMenuItem(value: therapist, child: Text(therapist.therapistName));
      }).toList(),
      decoration: const InputDecoration(labelText: 'Terapeuta', border: OutlineInputBorder()),
    );
  }

  Widget _buildSlotsGrid(List<String> slots) {
    if (slots.isEmpty) {
      return const Center(child: Text('Nenhum horário disponível para esta data.'));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = slot == _selectedSlot;
        return ElevatedButton(
          onPressed: () => setState(() => _selectedSlot = slot),
          style: ElevatedButton.styleFrom(backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300, foregroundColor: isSelected ? Colors.white : Colors.black87),
          child: Text(slot),
        );
      },
    );
  }

  // O antigo "Plano Terapêutico" pode ser removido ou mantido conforme sua preferência.
  Widget _buildPlanoTerapeuticoTab() {
    return const Center(child: Text('Plano Terapêutico (em breve)'));
  }
}
