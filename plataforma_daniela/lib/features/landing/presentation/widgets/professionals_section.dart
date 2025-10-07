import 'package:flutter/material.dart';
import 'section_title.dart';
import 'pro_card.dart';

class ProfessionalsSection extends StatelessWidget {
  const ProfessionalsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle('Profissionais'),
        SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ProCard(name: 'Daniele Gomes', role: 'Psic�loga | CRP 00/0000'),
            ProCard(name: 'Ana Paula', role: 'Terapeuta Sist�mica'),
            ProCard(name: 'Carlos Andrade', role: 'Psicoterapeuta Integrativo'),
          ],
        ),
      ],
    );
  }
}
