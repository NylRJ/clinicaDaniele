import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart'; // Você precisará criar esta tela
import '../../features/appointment/presentation/screens/appointment_screen.dart';
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
            // Não precisa mais passar parâmetros
            return const TherapistAgendaScreen();
          } else {
            // Não precisa mais passar parâmetros
            return const AppointmentScreen();
          }
        } else if (state is Unauthenticated) {
          // Se não estiver autenticado, vai para a tela de login (crie um placeholder para ela)
          return const LoginScreen();
        }

        // Estado de loading ou inicial
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
