import 'package:flutter/material.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'package:plataforma_daniela/core/widgets/brand_logo.dart';

class NavKeys {
  const NavKeys({required this.sobre, required this.servicos, required this.profissionais, required this.depoimentos, required this.contato});
  final GlobalKey sobre;
  final GlobalKey servicos;
  final GlobalKey profissionais;
  final GlobalKey depoimentos;
  final GlobalKey contato;
}

class Navbar extends StatelessWidget {
  const Navbar({super.key, required this.onTap, required this.keys});
  final Future<void> Function(GlobalKey) onTap;
  final NavKeys keys;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: LayoutBuilder(
          builder: (context, c) {
            final narrow = c.maxWidth < 900;
            final brand = Row(
              children: const [
                BrandLogo(size: 36, darkPlate: true),
                SizedBox(width: 10),
                Text(
                  'Reconstruir Clinic',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: BrandColors.charcoal),
                ),
              ],
            );
            final links = Row(
              children: [
                _NavBtn('Sobre', () => onTap(keys.sobre)),
                _NavBtn('Serviços', () => onTap(keys.servicos)),
                _NavBtn('Profissionais', () => onTap(keys.profissionais)),
                _NavBtn('Depoimentos', () => onTap(keys.depoimentos)),
                const SizedBox(width: 8),
                _PrimaryBtn('Agendar', () => onTap(keys.contato)),
              ],
            );
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
          },
        ),
      ),
    );
  }
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
          style: const TextStyle(color: BrandColors.slate, fontSize: 14, fontWeight: FontWeight.w700),
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
