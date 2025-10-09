// ARQUIVO: lib/features/appointment/presentation/screens/appointment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// --- IMPORTS ESSENCIAIS ---
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/therapist_config_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
// -------------------------

import '../cubit/appointment_cubit.dart';
import '../cubit/appointment_state.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  TherapistConfigEntity? _selectedTherapist;
  DateTime? _selectedDate;
  String? _selectedSlot;
  // Mantém a lista de terapeutas entre estados (ex.: durante carregamento de horários)
  List<TherapistConfigEntity> _therapists = [];

  @override
  void initState() {
    super.initState();
    // Garante que o cubit de agendamento exista antes de o usar.
    if (BlocProvider.of<AppointmentCubit>(context, listen: false) != null) {
      context.read<AppointmentCubit>().fetchTherapists();
    }
  }

  void _onTherapistChanged(TherapistConfigEntity? therapist) {
    setState(() {
      _selectedTherapist = therapist;
      _selectedSlot = null; // Reseta o horário
    });
    _fetchSlots();
  }

  void _onDateChanged(DateTime? date) {
    if (date == null) return;
    setState(() {
      _selectedDate = date;
      _selectedSlot = null; // Reseta o horário
    });
    _fetchSlots();
  }

  void _fetchSlots() {
    if (_selectedTherapist != null && _selectedDate != null) {
      context.read<AppointmentCubit>().fetchAvailableSlots(therapistId: _selectedTherapist!.therapistId, date: _selectedDate!);
    }
  }

  void _submitAppointment() {
    final authState = context.read<AuthCubit>().state;

    if (authState is Authenticated && _selectedTherapist != null && _selectedDate != null && _selectedSlot != null) {
      final patient = authState.user;
      final hour = int.parse(_selectedSlot!.split(':')[0]);
      final minute = int.parse(_selectedSlot!.split(':')[1]);
      final startTime = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, hour, minute);

      final appointment = AppointmentEntity(
        id: '', // Firestore irá gerar o ID
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, preencha todos os campos para agendar.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Agendamento')),
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${state.message}'), backgroundColor: Colors.red));
          }
          if (state is AppointmentCreated) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Consulta agendada com sucesso!'), backgroundColor: Colors.green));
            setState(() {
              _selectedTherapist = null;
              _selectedDate = null;
              _selectedSlot = null;
            });
            context.read<AppointmentCubit>().fetchTherapists();
          }
        },
        builder: (context, state) {
          // Atualiza a lista local apenas quando terapeutas são carregados
          if (state is TherapistsLoaded) {
            _therapists = state.therapists;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTherapistSelector(_therapists, state is AppointmentLoading && _therapists.isEmpty),
                const SizedBox(height: 20),
                _buildDatePicker(),
                const SizedBox(height: 20),
                if (state is AvailableSlotsLoading) const Center(child: CircularProgressIndicator()),
                if (state is AvailableSlotsLoaded) _buildSlotsGrid(state.slots),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: (_selectedSlot != null && state is! AppointmentLoading && state is! AvailableSlotsLoading) ? _submitAppointment : null,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: (state is AppointmentLoading) ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('Confirmar Agendamento'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTherapistSelector(List<TherapistConfigEntity> therapists, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
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

  Widget _buildDatePicker() {
    return ListTile(
      title: Text(_selectedDate == null ? 'Selecione uma data' : 'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
      trailing: const Icon(Icons.calendar_today),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      onTap: () async {
        final date = await showDatePicker(context: context, initialDate: _selectedDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
        _onDateChanged(date);
      },
    );
  }

  Widget _buildSlotsGrid(List<String> slots) {
    if (_selectedDate == null) return const SizedBox.shrink();
    if (slots.isEmpty) {
      return const Center(child: Text('Nenhum horário disponível para esta data.', textAlign: TextAlign.center));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.5),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = slot == _selectedSlot;
        return ElevatedButton(
          onPressed: () => setState(() => _selectedSlot = slot),
          // ######################################################
          // ##                CORREÇÃO APLICADA AQUI            ##
          // ######################################################
          style: ElevatedButton.styleFrom(backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300, foregroundColor: isSelected ? Colors.white : Colors.black87),
          child: Text(slot),
        );
      },
    );
  }
}
