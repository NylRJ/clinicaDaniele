import 'package:flutter/material.dart';
import '../../styles/brand_colors.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key, required this.text, required this.author});
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.format_quote, color: BrandColors.gold),
              const SizedBox(height: 8),
              Text(text, style: const TextStyle(fontSize: 14, color: BrandColors.slate, height: 1.5)),
              const SizedBox(height: 10),
              // LINHA CORRIGIDA ABAIXO
              Text(
                '— $author',
                style: const TextStyle(fontSize: 12, color: BrandColors.charcoal, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
