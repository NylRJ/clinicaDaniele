import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plataforma_daniela/features/booking/presentation/screens/booking_screen.dart';
import 'package:plataforma_daniela/features/landing/presentation/screens/landing_elegante_v2.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/therapist_dashboard/presentation/screens/therapist_agenda_screen.dart';

class HomeRedirectScreen extends StatelessWidget {
  const HomeRedirectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          if (user.role == 'terapeuta') {
            // Redireciona o terapeuta para a sua agenda.
            return const TherapistAgendaScreen();
          } else {
            // Redireciona o paciente para a tela de agendamentos.
            return const BookingScreen();
          }
        } else if (state is Unauthenticated) {
          // CORREÇÃO: Se não estiver autenticado, mostra a Landing Page.
          return const LandingEleganteV2();
        }

        // Enquanto o estado de autenticação é verificado, mostra um loading.
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
