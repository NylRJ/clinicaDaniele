import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/therapist_config_entity.dart';
import '../cubit/appointment_cubit.dart';
import '../cubit/appointment_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class AppointmentScreen extends StatefulWidget {
  // O construtor agora é simples, sem parâmetros necessários.
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  TherapistConfigEntity? _selectedTherapist;
  DateTime? _selectedDate;
  String? _selectedSlot;

  @override
  void initState() {
    super.initState();
    // Injeta o Cubit para esta tela e busca os terapeutas ao iniciar.
    // O BlocProvider pode ser movido para a árvore de widgets acima se necessário.
    context.read<AppointmentCubit>().fetchTherapists();
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
        id: '', // Firestore gerará o ID
        patientId: patient.uid,
        patientName: patient.name,
        therapistId: _selectedTherapist!.therapistId,
        therapistName: _selectedTherapist!.therapistName,
        startTime: startTime,
        endTime: startTime.add(Duration(minutes: _selectedTherapist!.sessionDurationMinutes)),
        status: 'agendado',
      );
      context.read<AppointmentCubit>().submitAppointment(appointment);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, complete todos os campos para agendar.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Agendamento')),
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${state.message}')));
          }
          if (state is AppointmentCreated) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Consulta agendada com sucesso!')));
            // Opcional: navegar para outra tela ou limpar o formulário
            setState(() {
              _selectedTherapist = null;
              _selectedDate = null;
              _selectedSlot = null;
            });
          }
        },
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Seleção do Terapeuta
                if (state is TherapistsLoaded) _buildTherapistSelector(state.therapists),
                const SizedBox(height: 20),

                // 2. Seleção da Data
                _buildDatePicker(),
                const SizedBox(height: 20),

                // 3. Seleção de Horário
                if (state is AvailableSlotsLoaded) _buildSlotsGrid(state.slots),
                if (state is AppointmentLoading && _selectedDate != null) const Center(child: CircularProgressIndicator()),

                const SizedBox(height: 40),

                // 4. Botão de Confirmação
                ElevatedButton(
                  onPressed: (_selectedSlot != null) ? _submitAppointment : null,
                  child: const Text('Confirmar Agendamento'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTherapistSelector(List<TherapistConfigEntity> therapists) {
    return DropdownButtonFormField<TherapistConfigEntity>(
      value: _selectedTherapist,
      hint: const Text('Selecione um terapeuta'),
      onChanged: (therapist) {
        setState(() {
          _selectedTherapist = therapist;
          _selectedSlot = null; // Reseta o horário ao mudar o terapeuta
        });
        _fetchSlots();
      },
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
      onTap: () async {
        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
        if (date != null) {
          setState(() {
            _selectedDate = date;
            _selectedSlot = null; // Reseta o horário ao mudar a data
          });
          _fetchSlots();
        }
      },
    );
  }

  Widget _buildSlotsGrid(List<String> slots) {
    if (slots.isEmpty) {
      return const Text('Nenhum horário disponível para esta data.', textAlign: TextAlign.center);
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = slot == _selectedSlot;
        return ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedSlot = slot;
            });
          },
          child: Text(slot),
          style: ElevatedButton.styleFrom(primary: isSelected ? Colors.blue.shade800 : Colors.blue, onPrimary: Colors.white),
        );
      },
    );
  }
}
