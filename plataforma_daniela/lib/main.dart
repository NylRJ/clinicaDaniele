import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plataforma_daniela/app/screens/home_redirect_screen.dart';
import 'package:plataforma_daniela/auth_gate.dart'; // <-- 1. IMPORTA O NOVO FICHEIRO
import 'package:plataforma_daniela/features/booking/presentation/screens/booking_screen.dart';
import 'package:plataforma_daniela/features/landing/presentation/screens/landing_elegante_v2.dart';
import 'package:plataforma_daniela/features/auth/presentation/screens/login_screen.dart';
import 'package:plataforma_daniela/features/auth/presentation/screens/register_screen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:plataforma_daniela/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plataforma_daniela/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:plataforma_daniela/features/auth/data/datasources/auth_firebase_datasource.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderApp(child: const MyApp()));
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
        '/': (context) => const HomeRedirectScreen(),
        // A Landing Page agora é acedida através do AuthGate se o utilizador não estiver autenticado
        '/landing': (context) => const LandingEleganteV2(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/booking': (context) => const BookingScreen(),
      },
    );
  }
}

class ProviderApp extends StatelessWidget {
  final Widget child;
  const ProviderApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl(
      authFirebaseDataSource: AuthFirebaseDataSourceImpl(
        firebaseAuth: firebase_auth.FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    );

    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(authRepository: authRepository)..appStarted(),
      child: child,
    );
  }
}
