// ARQUIVO: lib/features/booking/presentation/screens/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

// Esta é a classe principal da tela de agendamento.
// É um StatefulWidget porque precisa guardar o estado de qual terapeuta, dia e horário foram selecionados.
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Variáveis para guardar as seleções do usuário.
  TherapistConfigEntity? _selectedTherapist;
  DateTime _selectedDay = DateTime.now();
  String? _selectedSlot;

  // Este método é chamado uma vez quando a tela é criada.
  @override
  void initState() {
    super.initState();
    // Dispara a busca por terapeutas assim que a tela carrega.
    context.read<AppointmentCubit>().fetchTherapists();
  }

  // Chamado quando o usuário seleciona um terapeuta no menu suspenso.
  void _onTherapistChanged(TherapistConfigEntity? therapist) {
    setState(() {
      _selectedTherapist = therapist;
      _selectedSlot = null; // Limpa o horário selecionado para forçar uma nova escolha.
    });
    _fetchSlots(); // Inicia a busca por horários disponíveis.
  }

  // Chamado quando o usuário seleciona uma nova data no calendário.
  void _onDateChanged(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _selectedSlot = null; // Limpa o horário.
    });
    _fetchSlots();
  }

  // Função central para buscar os horários.
  void _fetchSlots() {
    // Só busca os horários se um terapeuta já foi selecionado.
    if (_selectedTherapist != null) {
      context.read<AppointmentCubit>().fetchAvailableSlots(therapistId: _selectedTherapist!.therapistId, date: _selectedDay);
    }
  }

  // Monta e envia o agendamento para o cubit.
  void _submitAppointment() {
    final authState = context.read<AuthCubit>().state;
    // Garante que o usuário está logado e todos os campos estão preenchidos.
    if (authState is Authenticated && _selectedTherapist != null && _selectedSlot != null) {
      final patient = authState.user;
      final hour = int.parse(_selectedSlot!.split(':')[0]);
      final minute = int.parse(_selectedSlot!.split(':')[1]);
      final startTime = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, hour, minute);

      // Cria o objeto de agendamento (AppointmentEntity).
      final appointment = AppointmentEntity(
        id: '', // O Firestore irá gerar o ID.
        patientId: patient.uid,
        patientName: patient.name,
        therapistId: _selectedTherapist!.therapistId,
        therapistName: _selectedTherapist!.therapistName,
        startTime: startTime,
        endTime: startTime.add(Duration(minutes: _selectedTherapist!.sessionDurationMinutes)),
        status: 'agendado',
      );
      // Envia o agendamento para ser processado pelo cubit.
      context.read<AppointmentCubit>().submitAppointment(appointment: appointment);
    } else {
      // Mostra um erro se algo estiver faltando.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, preencha todos os campos.')));
    }
  }

  // Constrói a interface visual da tela.
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BrandColors.ecru,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          // Ouve o AuthCubit para mostrar o nome do usuário.
          title: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return Text(
                  'Olá, ${state.user.name}',
                  style: const TextStyle(color: BrandColors.charcoal, fontWeight: FontWeight.bold, fontSize: 18),
                );
              }
              return const Text(
                'Minha Área',
                style: TextStyle(color: BrandColors.charcoal, fontWeight: FontWeight.bold),
              );
            },
          ),
          actions: [
            // Botão de Logout
            IconButton(
              icon: const Icon(Icons.logout, color: BrandColors.charcoal),
              onPressed: () async {
                context.read<AuthCubit>().signOut();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                }
              },
            ),
          ],
          // As abas "Agendamento" e "Plano Terapêutico".
          bottom: const TabBar(
            labelColor: BrandColors.charcoal,
            unselectedLabelColor: BrandColors.slate,
            indicatorColor: BrandColors.gold,
            tabs: [
              Tab(text: 'Agendamento'),
              Tab(text: 'Plano Terapêutico'),
            ],
          ),
        ),
        body: Stack(
          children: [
            const Positioned.fill(child: AppBackground()),
            // Conteúdo de cada aba.
            TabBarView(children: [_buildAgendamentoTab(), _buildPlanoTerapeuticoTab()]),
          ],
        ),
      ),
    );
  }

  // Constrói o conteúdo da aba "Agendamento".
  Widget _buildAgendamentoTab() {
    // Ouve o AppointmentCubit para reagir a mudanças de estado (carregando, sucesso, erro).
    return BlocConsumer<AppointmentCubit, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
        if (state is AppointmentCreated) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Consulta agendada com sucesso!'), backgroundColor: Colors.green));
          setState(() {
            _selectedSlot = null; // Limpa o horário após agendar.
          });
          _fetchSlots(); // Atualiza a lista de horários.
        }
      },
      builder: (context, state) {
        List<TherapistConfigEntity> therapists = [];
        if (state is TherapistsLoaded) {
          therapists = state.therapists;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mostra um indicador de progresso enquanto carrega os terapeutas.
              if (state is AppointmentLoading && state is! AvailableSlotsLoading)
                const Center(child: CircularProgressIndicator())
              // Se os terapeutas foram carregados, mostra o seletor.
              else if (state is TherapistsLoaded)
                _buildTherapistSelector(state.therapists)
              // Se deu erro, mostra a mensagem.
              else if (state is AppointmentError)
                Center(child: Text(state.message))
              // Em outros casos, mostra o seletor vazio.
              else
                _buildTherapistSelector(therapists),

              const SizedBox(height: 20),

              // Widget para selecionar a data.
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

              // Mostra o indicador de progresso ao buscar horários ou a grade de horários.
              if (state is AvailableSlotsLoading) const Center(child: CircularProgressIndicator()) else if (state is AvailableSlotsLoaded) _buildSlotsGrid(state.slots),

              const SizedBox(height: 40),
              // Botão para confirmar o agendamento.
              ElevatedButton(
                onPressed: _selectedSlot != null && state is! AppointmentLoading ? _submitAppointment : null,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: state is AppointmentLoading && state is! AvailableSlotsLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirmar Agendamento'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Constrói o menu suspenso para selecionar terapeutas.
  Widget _buildTherapistSelector(List<TherapistConfigEntity> therapists) {
    return DropdownButtonFormField<TherapistConfigEntity>(
      value: _selectedTherapist,
      hint: const Text('Selecione um terapeuta'),
      isExpanded: true,
      onChanged: _onTherapistChanged,
      items: therapists.map((therapist) {
        return DropdownMenuItem(value: therapist, child: Text(therapist.therapistName));
      }).toList(),
      decoration: const InputDecoration(labelText: 'Terapeuta', border: OutlineInputBorder()),
    );
  }

  // Constrói a grade de horários disponíveis.
  Widget _buildSlotsGrid(List<String> slots) {
    if (slots.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Nenhum horário disponível para esta data.', textAlign: TextAlign.center),
        ),
      );
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
          style: ElevatedButton.styleFrom(backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300, foregroundColor: isSelected ? Colors.white : Colors.black87),
          child: Text(slot),
        );
      },
    );
  }

  // Constrói o conteúdo da aba "Plano Terapêutico" (ainda um placeholder).
  Widget _buildPlanoTerapeuticoTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 60, color: BrandColors.slate),
            SizedBox(height: 16),
            Text(
              'O seu Plano Terapêutico',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: BrandColors.charcoal),
            ),
            SizedBox(height: 8),
            Text(
              'Neste espaço, encontrará o seu plano de tratamento, materiais e poderá interagir com o seu terapeuta.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: BrandColors.slate),
            ),
          ],
        ),
      ),
    );
  }
}
