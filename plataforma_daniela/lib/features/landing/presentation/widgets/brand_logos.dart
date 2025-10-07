import 'package:flutter/material.dart';
import '../../styles/brand_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.size, this.darkPlate = false});
  final double size;
  final bool darkPlate;

  @override
  Widget build(BuildContext context) {
    final img = Image.asset('assets/logo_reconstruir.png', width: size, height: size, fit: BoxFit.contain);
    if (!darkPlate) return img;

    return Container(
      padding: EdgeInsets.all(size * 0.12),
      decoration: BoxDecoration(
        color: BrandColors.charcoal,
        borderRadius: BorderRadius.circular(size * 0.18),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: img,
    );
  }
}
