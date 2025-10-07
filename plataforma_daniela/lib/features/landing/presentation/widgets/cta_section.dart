import 'package:flutter/material.dart';
import '../../styles/brand_colors.dart';
import 'section_title.dart';

class CTASection extends StatelessWidget {
  const CTASection({super.key});
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
          const SectionTitle('Pronta(o) para come�ar?', subtitle: 'Agende uma sess�o e d� o primeiro passo.'),
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
              onPressed: () {},
              child: const Text('Agendar agora'),
            ),
          ),
        ],
      ),
    );
  }
}
