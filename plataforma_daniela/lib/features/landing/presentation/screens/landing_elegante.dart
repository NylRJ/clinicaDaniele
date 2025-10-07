import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Landing page profissional (V2)
/// - Logo real (assets/logo_reconstruir.png) com placa escura para contraste
/// - Parallax com círculos + espiral dourada
/// - Navbar responsiva (menu hambúrguer) + rolagem suave entre seções
/// - Paleta alinhada à marca (dourado/preto/ecru)
///
/// pubspec.yaml:
/// flutter:
///   assets:
///     - assets/logo_reconstruir.png

/* ---------- BRAND ---------- */

class BrandColors {
  static const gold = Color(0xFFD4AF37);
  static const charcoal = Color(0xFF111111);
  static const ecru = Color(0xFFF7F5EF);
  static const slate = Color(0xFF475569);
  static const accent = Color(0xFF5E60CE);
}

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.size, this.darkPlate = false});
  final double size;
  final bool darkPlate;

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(
      'assets/logo_reconstruir.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );

    if (!darkPlate) return img;

    return Container(
      padding: EdgeInsets.all(size * 0.12),
      decoration: BoxDecoration(
        color: BrandColors.charcoal,
        borderRadius: BorderRadius.circular(size * 0.18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: img,
    );
  }
}

/* ---------- PAGE ---------- */

class LandingElegante extends StatefulWidget {
  const LandingElegante({super.key});
  @override
  State<LandingElegante> createState() => _LandingEleganteState();
}

class _LandingEleganteState extends State<LandingElegante> with TickerProviderStateMixin {
  final _scroll = ScrollController();
  final _kSobre = GlobalKey();
  final _kServicos = GlobalKey();
  final _kProfissionais = GlobalKey();
  final _kDepoimentos = GlobalKey();
  final _kContato = GlobalKey();

  late final AnimationController _heroCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  Future<void> _goTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    _heroCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _NavDrawer(
        onTap: (k) async {
          Navigator.pop(context);
          await _goTo(k);
        },
        keys: _Keys(
          sobre: _kSobre,
          servicos: _kServicos,
          profissionais: _kProfissionais,
          depoimentos: _kDepoimentos,
          contato: _kContato,
        ),
      ),
      backgroundColor: BrandColors.ecru,
      body: Stack(
        children: [
          // Fundo com parallax
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _scroll,
              builder: (context, _) {
                final offset = (_scroll.hasClients ? _scroll.offset : 0) * 0.2;
                return CustomPaint(painter: _ParallaxPainter(offsetY: offset));
              },
            ),
          ),
          CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverToBoxAdapter(
                child: _Navbar(
                  keys: _Keys(
                    sobre: _kSobre,
                    servicos: _kServicos,
                    profissionais: _kProfissionais,
                    depoimentos: _kDepoimentos,
                    contato: _kContato,
                  ),
                  onTap: _goTo,
                ),
              ),
              SliverToBoxAdapter(
                child: _HeroSection(
                  ctrl: _heroCtrl,
                  onPrimaryCTA: () => _goTo(_kContato),
                ),
              ),
              SliverToBoxAdapter(
                child: _SectionWrapper(
                  key: _kSobre,
                  child: const _SobreSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: _SectionWrapper(
                  key: _kServicos,
                  child: const _ServicosSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: _SectionWrapper(
                  key: _kProfissionais,
                  child: const _ProfissionaisSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: _SectionWrapper(
                  key: _kDepoimentos,
                  child: const _DepoimentosSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: _SectionWrapper(
                  key: _kContato,
                  child: const _CTASection(),
                ),
              ),
              const SliverToBoxAdapter(child: _Footer()),
            ],
          ),
        ],
      ),
    );
  }
}

/* ---------- PARALLAX BG ---------- */

class _ParallaxPainter extends CustomPainter {
  const _ParallaxPainter({required this.offsetY});
  final double offsetY;

  @override
  void paint(Canvas canvas, Size size) {
    // Degradê
    final bg = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF9F7F0), Color(0xFFF2F0E8)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    // Círculos suaves
    final circlePaint = Paint()..color = BrandColors.gold.withAlpha(0x0F);
    canvas.drawCircle(Offset(size.width * 0.78, 180 - offsetY), 170, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.22, 420 - offsetY * 1.2), 130, circlePaint);

    // Espiral dourada
    _drawSpiral(
      canvas,
      center: Offset(size.width * 0.72, 260 - offsetY * 0.8),
      baseRadius: 10,
      turns: 5.2,
      stroke: BrandColors.gold.withAlpha(0x2E),
      strokeWidth: 2.0,
    );
  }

  @override
  bool shouldRepaint(covariant _ParallaxPainter oldDelegate) => oldDelegate.offsetY != offsetY;
}

void _drawSpiral(
  Canvas canvas, {
  required Offset center,
  required double baseRadius,
  required double turns,
  required Color stroke,
  double strokeWidth = 2.0,
}) {
  // r = a * e^(b*theta)
  const double b = 0.18;
  final path = Path();
  final double maxTheta = turns * 2 * math.pi;

  for (double t = 0; t <= maxTheta; t += 0.02) {
    final r = baseRadius * (math.exp(b * t));
    final x = center.dx + r * math.cos(t);
    final y = center.dy + r * math.sin(t);
    if (t == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }

  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..color = stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  // leve brilho
  canvas.drawPath(path, paint);
  canvas.drawPath(
      path,
      paint
        ..color = stroke.withAlpha(0x1A)
        ..strokeWidth = strokeWidth + 2);
}

/* ---------- NAV ---------- */

class _Keys {
  const _Keys({
    required this.sobre,
    required this.servicos,
    required this.profissionais,
    required this.depoimentos,
    required this.contato,
  });
  final GlobalKey sobre;
  final GlobalKey servicos;
  final GlobalKey profissionais;
  final GlobalKey depoimentos;
  final GlobalKey contato;
}

class _Navbar extends StatelessWidget {
  const _Navbar({required this.onTap, required this.keys});
  final Future<void> Function(GlobalKey) onTap;
  final _Keys keys;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: LayoutBuilder(builder: (context, c) {
          final narrow = c.maxWidth < 900;

          final brand = Row(children: const [
            BrandLogo(size: 36, darkPlate: true),
            SizedBox(width: 10),
            Text(
              'Reconstruir Clinic',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: BrandColors.charcoal,
              ),
            ),
          ]);

          final links = Row(children: [
            _NavBtn('Sobre', () => onTap(keys.sobre)),
            _NavBtn('Serviços', () => onTap(keys.servicos)),
            _NavBtn('Profissionais', () => onTap(keys.profissionais)),
            _NavBtn('Depoimentos', () => onTap(keys.depoimentos)),
            const SizedBox(width: 8),
            _PrimaryBtn('Agendar', () => onTap(keys.contato)),
          ]);

          return Row(
            children: [
              brand,
              const Spacer(),
              if (!narrow)
                links
              else
                IconButton(
                  icon: const Icon(Icons.menu_rounded, color: BrandColors.charcoal),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _NavDrawer extends StatelessWidget {
  const _NavDrawer({required this.onTap, required this.keys});
  final Future<void> Function(GlobalKey) onTap;
  final _Keys keys;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Row(
              children: const [
                BrandLogo(size: 32, darkPlate: true),
                SizedBox(width: 8),
                Text('Reconstruir Clinic', style: TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
            const Divider(height: 24),
            _drawerItem('Sobre', () => onTap(keys.sobre)),
            _drawerItem('Serviços', () => onTap(keys.servicos)),
            _drawerItem('Profissionais', () => onTap(keys.profissionais)),
            _drawerItem('Depoimentos', () => onTap(keys.depoimentos)),
            _drawerItem('Agendar', () => onTap(keys.contato), bold: true),
          ],
        ),
      ),
    );
  }

  static Widget _drawerItem(String label, VoidCallback onPressed, {bool bold = false}) => ListTile(
        title: Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
        onTap: onPressed,
      );
}

class _NavBtn extends StatelessWidget {
  const _NavBtn(this.label, this.onPressed);
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: BrandColors.slate,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  const _PrimaryBtn(this.label, this.onPressed);
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: BrandColors.charcoal,
        foregroundColor: BrandColors.gold,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

/* ---------- HERO ---------- */

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.ctrl, required this.onPrimaryCTA});
  final AnimationController ctrl;
  final VoidCallback onPrimaryCTA;

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: ctrl, curve: Curves.easeOut);
    final slide = Tween<Offset>(begin: const Offset(0, .06), end: Offset.zero).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth >= 900;

            final left = FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: Column(
                  crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: const [
                    BrandLogo(size: 84, darkPlate: true),
                    SizedBox(height: 16),
                    Text(
                      'Reconstruir Clinic',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: BrandColors.charcoal,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Plataforma Integrada\nde Gestão Terapêutica',
                      style: TextStyle(
                        fontSize: 42,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: BrandColors.charcoal,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Conectamos pacientes e terapeutas com tecnologia, empatia e propósito.',
                      style: TextStyle(fontSize: 18, color: BrandColors.slate),
                    ),
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
                        const Text('© 2025 Reconstruir Clinic', style: TextStyle(fontSize: 12, color: Colors.black45)),
                      ],
                    ),
                  ),
                ),
              ),
            );

            return Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: wide ? Row(children: [Expanded(child: left), const SizedBox(width: 28), Expanded(child: right)]) : Column(children: [left, const SizedBox(height: 20), right]),
            );
          }),
        ),
      ),
    );
  }
}

/* ---------- SECTIONS ---------- */

class _SectionWrapper extends StatelessWidget {
  const _SectionWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: child,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: BrandColors.charcoal)),
      if (subtitle != null) ...[
        const SizedBox(height: 6),
        Text(subtitle!, style: const TextStyle(fontSize: 15, color: BrandColors.slate)),
      ],
    ]);
  }
}

class _SobreSection extends StatelessWidget {
  const _SobreSection();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      _SectionTitle('Sobre a Reconstruir Clinic', subtitle: 'Cuidado humano aliado à ciência e tecnologia.'),
      SizedBox(height: 14),
      Text(
        'Somos uma clínica comprometida com o bem-estar emocional. Nossa plataforma integra o agendamento, o acompanhamento e a comunicação entre pacientes e terapeutas, garantindo segurança e praticidade.',
        style: TextStyle(fontSize: 16, color: BrandColors.slate, height: 1.5),
      ),
    ]);
  }
}

class _ServicosSection extends StatelessWidget {
  const _ServicosSection();
  @override
  Widget build(BuildContext context) {
    final cards = [
      _ServiceCard(icon: Icons.psychology, title: 'Psicoterapia Individual', desc: 'Sessões personalizadas focadas nas suas necessidades.'),
      _ServiceCard(icon: Icons.family_restroom, title: 'Casal e Família', desc: 'Atendimento para relações mais saudáveis.'),
      _ServiceCard(icon: Icons.self_improvement, title: 'Grupos e Workshops', desc: 'Crescimento pessoal com mediação profissional.'),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle('Nossos serviços'),
      const SizedBox(height: 16),
      LayoutBuilder(builder: (context, c) {
        final wide = c.maxWidth >= 900;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards
              .map((w) => SizedBox(
                    width: wide ? (c.maxWidth - 32) / 3 : c.maxWidth,
                    child: w,
                  ))
              .toList(),
        );
      }),
    ]);
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.icon, required this.title, required this.desc});
  final IconData icon;
  final String title;
  final String desc;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: BrandColors.charcoal, shape: BoxShape.circle),
            child: const Icon(Icons.star_border_rounded, color: BrandColors.gold),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: BrandColors.charcoal)),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 14, color: BrandColors.slate, height: 1.45)),
        ]),
      ),
    );
  }
}

class _ProfissionaisSection extends StatelessWidget {
  const _ProfissionaisSection();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle('Profissionais'),
      const SizedBox(height: 16),
      Wrap(spacing: 16, runSpacing: 16, children: const [
        _ProCard(name: 'Daniele Gomes', role: 'Psicóloga | CRP 00/0000'),
        _ProCard(name: 'Ana Paula', role: 'Terapeuta Sistêmica'),
        _ProCard(name: 'Carlos Andrade', role: 'Psicoterapeuta Integrativo'),
      ]),
    ]);
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard({required this.name, required this.role});
  final String name;
  final String role;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(color: BrandColors.charcoal, shape: BoxShape.circle),
              child: const Icon(Icons.person_outline, color: BrandColors.gold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800, color: BrandColors.charcoal)),
                const SizedBox(height: 2),
                Text(role, style: const TextStyle(fontSize: 12, color: BrandColors.slate)),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}

class _DepoimentosSection extends StatelessWidget {
  const _DepoimentosSection();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle('O que dizem nossos pacientes'),
      const SizedBox(height: 16),
      Wrap(spacing: 16, runSpacing: 16, children: const [
        _QuoteCard(text: 'Profissionalismo e acolhimento que mudaram minha vida.', author: 'R.M.'),
        _QuoteCard(text: 'Agendamento fácil e atendimento humanizado.', author: 'G.S.'),
        _QuoteCard(text: 'Me senti segura e bem cuidada em todo o processo.', author: 'M.A.'),
      ]),
    ]);
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.text, required this.author});
  final String text;
  final String author;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.format_quote, color: BrandColors.gold),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(fontSize: 14, color: BrandColors.slate, height: 1.5)),
            const SizedBox(height: 10),
            Text('— $author', style: const TextStyle(fontSize: 12, color: BrandColors.charcoal, fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }
}

class _CTASection extends StatelessWidget {
  const _CTASection();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(children: [
        const _SectionTitle('Pronta(o) para começar?', subtitle: 'Agende uma sessão e dê o primeiro passo.'),
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
      ]),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(children: const [
            Divider(height: 32),
            Text('© 2025 Reconstruir Clinic • Todos os direitos reservados', style: TextStyle(fontSize: 12, color: Colors.black45)),
          ]),
        ),
      ),
    );
  }
}
