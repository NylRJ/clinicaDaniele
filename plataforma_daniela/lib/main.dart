import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plataforma_daniela/features/booking/presentation/screens/booking_screen.dart';
import 'package:plataforma_daniela/features/landing/presentation/screens/landing_elegante_v2.dart';
import 'package:plataforma_daniela/features/auth/presentation/screens/login_screen.dart';
import 'package:plataforma_daniela/features/auth/presentation/screens/register_screen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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
      home: const LandingEleganteV2(),
      routes: {'/login': (_) => const LoginScreen(), '/register': (_) => const RegisterScreen(), '/booking': (context) => const BookingScreen()},
    );
  }
}
