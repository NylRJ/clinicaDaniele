import 'package:flutter/material.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';

class ProCard extends StatelessWidget {
  const ProCard({super.key, required this.name, required this.role});
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
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(color: BrandColors.charcoal, shape: BoxShape.circle),
                child: const Icon(Icons.person_outline, color: BrandColors.gold),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w800, color: BrandColors.charcoal),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: const TextStyle(fontSize: 12, color: BrandColors.slate),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
