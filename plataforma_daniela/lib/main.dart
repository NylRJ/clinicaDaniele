import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plataforma_daniela/auth_gate.dart'; // <-- 1. IMPORTA O NOVO FICHEIRO
import 'package:plataforma_daniela/features/booking/presentation/screens/booking_screen.dart';
import 'package:plataforma_daniela/features/landing/presentation/screens/landing_elegante_v2.dart';
import 'package:plataforma_daniela/features/auth/presentation/screens/login_screen.dart';
import 'package:plataforma_daniela/features/auth/presentation/screens/register_screen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reconstruir Clinic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD4AF37)),
        textTheme: GoogleFonts.interTextTheme(),
        primaryTextTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        // <-- 2. A ROTA INICIAL AGORA APONTA PARA O AUTHGATE
        '/': (context) => const AuthGate(),
        // A Landing Page agora é acedida através do AuthGate se o utilizador não estiver autenticado
        '/landing': (context) => const LandingEleganteV2(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/booking': (context) => const BookingScreen(),
      },
    );
  }
}
