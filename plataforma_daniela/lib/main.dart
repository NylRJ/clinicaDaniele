// ARQUIVO: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plataforma_daniela/app/screens/home_redirect_screen.dart';
import 'package:plataforma_daniela/features/appointment/data/datasources/appointment_firebase_datasource.dart';
import 'package:plataforma_daniela/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:plataforma_daniela/features/appointment/presentation/cubit/appointment_cubit.dart';
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
  runApp(const ProviderApp());
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
        '/': (context) => const HomeRedirectScreen(),
        '/landing': (context) => const LandingEleganteV2(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/booking': (context) => const BookingScreen(),
      },
    );
  }
}

// O ProviderApp agora envolve toda a aplicação
class ProviderApp extends StatelessWidget {
  const ProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instâncias do Firestore e Auth
    final firestore = FirebaseFirestore.instance;
    final firebaseAuth = firebase_auth.FirebaseAuth.instance;

    // Datasource de Autenticação
    final authDataSource = AuthFirebaseDataSourceImpl(firebaseAuth: firebaseAuth, firestore: firestore);
    // Repositório de Autenticação
    final authRepository = AuthRepositoryImpl(authFirebaseDataSource: authDataSource);

    // Datasource de Agendamento
    final appointmentDataSource = AppointmentFirebaseDataSourceImpl(firestore);
    // Repositório de Agendamento
    final appointmentRepository = AppointmentRepositoryImpl(appointmentFirebaseDataSource: appointmentDataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(authRepository: authRepository)..appStarted()),
        // CORREÇÃO: AppointmentCubit agora está disponível para toda a aplicação
        BlocProvider<AppointmentCubit>(create: (_) => AppointmentCubit(repository: appointmentRepository)),
      ],
      child: const MyApp(),
    );
  }
}
