import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plataforma_daniela/features/landing/presentation/screens/landing_elegante.dart';
import 'firebase_options.dart';
import 'features/landing/presentation/screens/landing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plataforma Terapêutica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5E60CE)),
        useMaterial3: true,
      ),
      home: const LandingElegante(),
    );
  }
}
