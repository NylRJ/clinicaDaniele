import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'package:plataforma_daniela/features/landing/presentation/widgets/widgets.dart';

class LandingEleganteV2 extends StatefulWidget {
  const LandingEleganteV2({super.key});
  @override
  State<LandingEleganteV2> createState() => _LandingEleganteV2State();
}

class _LandingEleganteV2State extends State<LandingEleganteV2> with TickerProviderStateMixin {
  final _scroll = ScrollController();
  final _kSobre = GlobalKey();
  final _kServicos = GlobalKey();
  final _kProfissionais = GlobalKey();
  final _kDepoimentos = GlobalKey();
  final _kContato = GlobalKey();

  late final AnimationController _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();

  Future<void> _goTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 550), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _heroCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    final slide = Tween<Offset>(begin: const Offset(0, .06), end: Offset.zero).animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));

    return Scaffold(
      drawer: NavDrawer(
        onTap: (k) async {
          Navigator.pop(context);
          await _goTo(k);
        },
        keys: NavKeys(sobre: _kSobre, servicos: _kServicos, profissionais: _kProfissionais, depoimentos: _kDepoimentos, contato: _kContato),
      ),
      backgroundColor: BrandColors.ecru,
      body: Stack(
        children: [
          Positioned.fill(child: ParallaxBackground(scroll: _scroll)),
          CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverToBoxAdapter(
                child: Navbar(
                  onTap: _goTo,
                  keys: NavKeys(sobre: _kSobre, servicos: _kServicos, profissionais: _kProfissionais, depoimentos: _kDepoimentos, contato: _kContato),
                ),
              ),
              SliverToBoxAdapter(
                child: HeroSection(onPrimaryCTA: () => _goTo(_kContato), fade: fade, slide: slide),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper(key: _kSobre, child: const _SobreSection()),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper(key: _kServicos, child: const ServicesSection()),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper(key: _kProfissionais, child: const ProfessionalsSection()),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper(key: _kDepoimentos, child: const TestimonialsSection()),
              ),
              SliverToBoxAdapter(
                child: SectionWrapper(key: _kContato, child: const CTASection()),
              ),
              const SliverToBoxAdapter(child: Footer()),
            ],
          ),
        ],
      ),
    );
  }
}

class _SobreSection extends StatelessWidget {
  const _SobreSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sobre a Reconstruir Clinic',
          style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700, color: BrandColors.charcoal),
        ),
        const SizedBox(height: 14),
        const Text(
          'Somos uma clínica comprometida com o bem-estar emocional. Nossa plataforma integra o agendamento, o acompanhamento e a comunicação entre pacientes e terapeutas, garantindo segurança e praticidade.',
          style: TextStyle(fontSize: 16, color: BrandColors.slate, height: 1.5),
        ),
      ],
    );
  }
}
