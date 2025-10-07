import 'package:flutter/material.dart';
import 'section_title.dart';
import '../widgets/widgets.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle('O que dizem nossos pacientes'),
        SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            QuoteCard(text: 'Profissionalismo e acolhimento que mudaram minha vida.', author: 'R.M.'),
            QuoteCard(text: 'Agendamento f�cil e atendimento humanizado.', author: 'G.S.'),
            QuoteCard(text: 'Me senti segura e bem cuidada em todo o processo.', author: 'M.A.'),
          ],
        ),
      ],
    );
  }
}
