import 'package:flutter/material.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'package:plataforma_daniela/core/widgets/brand_logo.dart';
import 'package:plataforma_daniela/core/widgets/app_background.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.ecru,
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BrandLogo(size: 84),
                const SizedBox(height: 16),
                const Text(
                  'Bem-vindo(a) de volta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: BrandColors.charcoal),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Acesse sua conta para continuar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: BrandColors.slate),
                ),
                const SizedBox(height: 32),
                // Campo de Email
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                // Campo de Senha
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                // Botão de Login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: BrandColors.charcoal,
                    foregroundColor: BrandColors.gold,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // Lógica de login a ser implementada
                  },
                  child: const Text('Entrar', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 24),
                // Link para Cadastro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem uma conta?', style: TextStyle(color: BrandColors.slate)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(color: BrandColors.charcoal, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
