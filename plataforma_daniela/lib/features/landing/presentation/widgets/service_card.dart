import 'package:flutter/material.dart';
import '../../styles/brand_colors.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.icon, required this.title, required this.desc});
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: BrandColors.charcoal, shape: BoxShape.circle),
              child: const Icon(Icons.star_border_rounded, color: BrandColors.gold),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: BrandColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              desc,
              style: const TextStyle(fontSize: 14, color: BrandColors.slate, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
