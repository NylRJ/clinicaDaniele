import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../styles/brand_colors.dart';

class ParallaxBackground extends StatelessWidget {
  const ParallaxBackground({super.key, required this.scroll});
  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scroll,
      builder: (context, _) {
        final offset = (scroll.hasClients ? scroll.offset : 0) * 0.2;
        return CustomPaint(painter: _ParallaxPainter(offsetY: offset));
      },
    );
  }
}

class _ParallaxPainter extends CustomPainter {
  const _ParallaxPainter({required this.offsetY});
  final double offsetY;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF9F7F0), Color(0xFFF2F0E8)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final circlePaint = Paint()..color = BrandColors.gold.withAlpha(0x0F);
    canvas.drawCircle(Offset(size.width * 0.78, 180 - offsetY), 170, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.22, 420 - offsetY * 1.2), 130, circlePaint);

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
  bool shouldRepaint(covariant _ParallaxPainter old) => old.offsetY != offsetY;

  void _drawSpiral(
    Canvas canvas, {
    required Offset center,
    required double baseRadius,
    required double turns,
    required Color stroke,
    double strokeWidth = 2.0,
  }) {
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
    canvas.drawPath(path, paint);
    canvas.drawPath(
      path,
      paint
        ..color = stroke.withAlpha(0x1A)
        ..strokeWidth = strokeWidth + 2,
    );
  }
}
