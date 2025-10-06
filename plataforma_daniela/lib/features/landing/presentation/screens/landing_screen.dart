import 'package:flutter/material.dart';

/// Landing Page básica/aprimorada para Web/Mobile
/// - Gradiente de fundo
/// - Layout responsivo
/// - Animações suaves (fade + slide)
/// - Botões: "Entrar" e "Cadastrar-se" com navegação simulada
///
/// Coloque este arquivo em:
/// lib/features/landing/presentation/screens/landing_screen.dart
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // inicia animações
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEEF1FF), Color(0xFFE7F5FF), Color(0xFFF8F9FF)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;
                  final content = _buildContent(context, isWide);
                  return isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: content.$1),
                            const SizedBox(width: 32),
                            Expanded(child: content.$2),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            content.$1,
                            const SizedBox(height: 28),
                            content.$2,
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Retorna (hero, ctaBox)
  (Widget, Widget) _buildContent(BuildContext context, bool isWide) {
    final hero = FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            // Logo/Marca (placeholder)
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: Color(0xFF5E60CE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_outline, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 20),
            const Text(
              'Plataforma Integrada\nde Gestão Terapêutica',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 36,
                height: 1.15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D2A45),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Conectamos pacientes e terapeutas com tecnologia, empatia e propósito.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );

    final cta = FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: _CTABox(
          onLogin: () => _openMock(context, title: 'Login'),
          onRegister: () => _openMock(context, title: 'Cadastro'),
        ),
      ),
    );

    return (hero, cta);
  }

  void _openMock(BuildContext context, {required String title}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _MockScreen(title: title),
      ),
    );
  }
}

class _CTABox extends StatelessWidget {
  const _CTABox({required this.onLogin, required this.onRegister});
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Comece agora',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E60CE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onLogin,
                child: const Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF5E60CE), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onRegister,
                child: const Text('Cadastrar-se', style: TextStyle(fontSize: 16, color: Color(0xFF5E60CE))),
              ),
            ),
            const SizedBox(height: 14),
            const Divider(height: 24),
            const Text(
              '© 2025 Clínica Daniela Gomes • Todos os direitos reservados',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}

/// Telas mock para simular navegação de Login/Cadastro sem depender de outras features
class _MockScreen extends StatelessWidget {
  const _MockScreen({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$title (mock)', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
