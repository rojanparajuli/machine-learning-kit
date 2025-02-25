import 'package:flutter/material.dart';

class TextPainterWidget extends StatelessWidget {
  final String text;

  const TextPainterWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 400), 
      painter: TextCanvasPainter(text),
    );
  }
}

class TextCanvasPainter extends CustomPainter {
  final String text;

  TextCanvasPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width);
    textPainter.paint(canvas, const Offset(20, 50));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
