import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'package:plataforma_daniela/core/widgets/app_background.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Usamos o DefaultTabController para gerir o estado das abas.
    return DefaultTabController(
      length: 2, // Temos 2 abas: Agendamento e Plano Terapêutico
      child: Scaffold(
        backgroundColor: BrandColors.ecru,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text(
            'Minha Área',
            style: TextStyle(color: BrandColors.charcoal, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: BrandColors.charcoal),
              onPressed: () async {
                await _auth.signOut();
                // Após o logout, envia o utilizador de volta para a landing page
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                }
              },
            ),
          ],
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
            TabBarView(
              children: [
                // Conteúdo da Aba de Agendamento (Placeholder)
                _buildAgendamentoTab(),

                // Conteúdo da Aba de Plano Terapêutico (Placeholder)
                _buildPlanoTerapeuticoTab(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget de placeholder para a aba de Agendamento
  Widget _buildAgendamentoTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 60, color: BrandColors.slate),
            SizedBox(height: 16),
            Text(
              'Calendário de Agendamento',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: BrandColors.charcoal),
            ),
            SizedBox(height: 8),
            Text(
              'Aqui poderá ver os horários disponíveis e marcar a sua próxima sessão.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: BrandColors.slate),
            ),
          ],
        ),
      ),
    );
  }

  // Widget de placeholder para a aba de Plano Terapêutico
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
