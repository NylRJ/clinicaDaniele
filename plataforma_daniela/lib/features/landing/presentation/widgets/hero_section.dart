import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'package:plataforma_daniela/core/widgets/brand_logo.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onPrimaryCTA, required this.fade, required this.slide});
  final VoidCallback onPrimaryCTA;
  final Animation<double> fade;
  final Animation<Offset> slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 900;

              final left = FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: Column(
                    crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                    children: [
                      const BrandLogo(size: 84, darkPlate: true),
                      const SizedBox(height: 16),
                      const Text(
                        'Reconstruir Clinic',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: BrandColors.charcoal),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        // CORRIGIDO AQUI
                        'Plataforma Integrada\nde Gestão Terapêutica',
                        style: GoogleFonts.playfairDisplay(fontSize: 42, height: 1.1, fontWeight: FontWeight.w700, color: BrandColors.charcoal),
                      ),
                      const SizedBox(height: 12),
                      // CORRIGIDO AQUI
                      const Text('Conectamos pacientes e terapeutas com tecnologia, empatia e propósito.', style: TextStyle(fontSize: 18, color: BrandColors.slate)),
                    ],
                  ),
                ),
              );

              final right = FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Comece agora', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: 260,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: BrandColors.charcoal,
                                foregroundColor: BrandColors.gold,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: onPrimaryCTA,
                              // CORRIGIDO AQUI
                              child: const Text('Agendar sessão'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 260,
                            height: 48,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: BrandColors.charcoal, width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: () {},
                              child: const Text('Sou terapeuta'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // CORRIGIDO AQUI
                          const Text('© 2025 Reconstruir Clinic', style: TextStyle(fontSize: 12, color: Colors.black45)),
                        ],
                      ),
                    ),
                  ),
                ),
              );

              return Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: wide
                    ? Row(
                        children: [
                          Expanded(child: left),
                          const SizedBox(width: 28),
                          Expanded(child: right),
                        ],
                      )
                    : Column(children: [left, const SizedBox(height: 20), right]),
              );
            },
          ),
        ),
      ),
    );
  }
}
