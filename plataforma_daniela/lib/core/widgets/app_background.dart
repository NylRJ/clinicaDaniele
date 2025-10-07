import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackgroundPainter(),
      child: Container(),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.black.withOpacity(0.06);

    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.1), size.width * 0.5, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.1), size.width * 0.65, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.1), size.width * 0.8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

