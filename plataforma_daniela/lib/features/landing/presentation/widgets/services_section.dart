import 'package:flutter/material.dart';
import 'service_card.dart';
import 'section_title.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = const [
      ServiceCard(
        icon: Icons.psychology,
        title: 'Psicoterapia Individual',
        desc: 'Sess�es personalizadas focadas nas suas necessidades.',
      ),
      ServiceCard(
        icon: Icons.family_restroom,
        title: 'Casal e Fam�lia',
        desc: 'Atendimento para rela��es mais saud�veis.',
      ),
      ServiceCard(
        icon: Icons.self_improvement,
        title: 'Grupos e Workshops',
        desc: 'Crescimento pessoal com media��o profissional.',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Nossos servi�os'),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 900;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: cards
                  .map(
                    (w) => SizedBox(
                      width: wide ? (c.maxWidth - 32) / 3 : c.maxWidth,
                      child: w,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}