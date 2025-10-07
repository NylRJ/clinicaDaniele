import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plataforma_daniela/features/booking/presentation/screens/booking_screen.dart';
import 'package:plataforma_daniela/features/landing/presentation/screens/landing_elegante_v2.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Se o snapshot ainda não tiver dados, mostre um ecrã de carregamento.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Se o utilizador tiver sessão iniciada (snapshot tem dados), mostre o ecrã de agendamento.
        if (snapshot.hasData) {
          return const BookingScreen();
        }

        // Caso contrário, mostre a landing page.
        return const LandingEleganteV2();
      },
    );
  }
}
