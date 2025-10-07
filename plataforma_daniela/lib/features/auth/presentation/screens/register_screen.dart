import 'package:flutter/material.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'package:plataforma_daniela/core/widgets/brand_logo.dart';
import 'package:plataforma_daniela/core/widgets/app_background.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Center(child: BrandLogo(size: 60, darkPlate: true)),
                        const SizedBox(height: 16),
                        const Text('Crie sua conta', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: BrandColors.charcoal)),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Nome', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Senha', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BrandColors.charcoal,
                            foregroundColor: BrandColors.gold,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {},
                          child: const Text('Cadastrar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Já tenho conta'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

