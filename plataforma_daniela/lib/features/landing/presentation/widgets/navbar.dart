import 'package:flutter/material.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'package:plataforma_daniela/core/widgets/brand_logo.dart';

// Helper class to hold the keys for navigation, now defined here.
class NavKeys {
  final GlobalKey sobre;
  final GlobalKey servicos;
  final GlobalKey profissionais;
  final GlobalKey depoimentos;
  final GlobalKey contato;

  const NavKeys({required this.sobre, required this.servicos, required this.profissionais, required this.depoimentos, required this.contato});
}

class Navbar extends StatelessWidget {
  final Function(GlobalKey) onTap;
  final NavKeys keys;
  // 1. Adicionamos o parâmetro para a nova função
  final VoidCallback onAgendarPressed;

  // 2. Adicionamos o parâmetro ao construtor
  const Navbar({super.key, required this.onTap, required this.keys, required this.onAgendarPressed});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BrandLogo(size: 48),
              if (isWide)
                Row(
                  children: [
                    _NavItem(onTap: () => onTap(keys.sobre), label: 'Sobre'),
                    _NavItem(onTap: () => onTap(keys.servicos), label: 'Serviços'),
                    _NavItem(onTap: () => onTap(keys.profissionais), label: 'Profissionais'),
                    _NavItem(onTap: () => onTap(keys.depoimentos), label: 'Depoimentos'),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      // 3. Usamos a função no botão "Agendar"
                      onPressed: onAgendarPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BrandColors.charcoal,
                        foregroundColor: BrandColors.gold,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                      ),
                      child: const Text('Agendar'),
                    ),
                  ],
                )
              else
                IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer()),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.onTap, required this.label});
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(color: BrandColors.charcoal, fontWeight: FontWeight.w600),
      ),
    );
  }
}
