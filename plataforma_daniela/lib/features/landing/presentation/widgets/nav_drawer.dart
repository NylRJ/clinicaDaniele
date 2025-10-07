import 'package:flutter/material.dart';
import '../../styles/brand_colors.dart';
import '../widgets/widgets.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key, required this.onTap, required this.keys});
  final Future<void> Function(GlobalKey) onTap;
  final NavKeys keys;

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
            _item('Sobre', () => onTap(keys.sobre)),
            _item('Servi�os', () => onTap(keys.servicos)),
            _item('Profissionais', () => onTap(keys.profissionais)),
            _item('Depoimentos', () => onTap(keys.depoimentos)),
            _item('Agendar', () => onTap(keys.contato), bold: true),
          ],
        ),
      ),
    );
  }

  static Widget _item(String label, VoidCallback onTap, {bool bold = false}) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: BrandColors.charcoal),
      ),
      onTap: onTap,
    );
  }
}
