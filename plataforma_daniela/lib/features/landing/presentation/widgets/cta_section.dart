import 'package:flutter/material.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'section_title.dart';

class CTASection extends StatelessWidget {
  // 1. Adicionamos o parâmetro para receber a função
  final VoidCallback onPressed;

  // 2. Atualizamos o construtor para exigir essa função
  const CTASection({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          const SectionTitle('Pronta(o) para começar?', subtitle: 'Agende uma sessão e dê o primeiro passo.'),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.charcoal,
                foregroundColor: BrandColors.gold,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 22),
              ),
              // 3. Usamos a função que foi passada para o widget
              onPressed: onPressed,
              child: const Text('Agendar agora'),
            ),
          ),
        ],
      ),
    );
  }
}
