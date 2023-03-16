
import 'dart:math';

import 'package:flutter/material.dart';

class RectPainter extends CustomPainter {
  RectPainter({
    required this.imageSize,
    required this.imageCornerPoints,
    required this.translated,
  });
  Size imageSize;
  List<List<Point<int>>> imageCornerPoints;
  List<String> translated;

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color.fromARGB(255, 82, 85, 82)
      ..style = PaintingStyle.fill;

    int i = 0;
    for (var cornerPoint in imageCornerPoints) {
      Point<int> point1 = cornerPoint[0];
      Point<int> point2 = cornerPoint[2];

      int x1 = point1.x;
      int y1 = point1.y;

      int x2 = point2.x;
      int y2 = point2.y;

      double dx1 = x1 * size.width / imageSize.width;
      double dy1 = y1 * size.height / imageSize.height;

      double dx2 = x2 * size.width / imageSize.width;
      double dy2 = y2 * size.height / imageSize.height;

      var a = Offset(dx1-20, dy1-5);
      var b = Offset(dx2+20, dy2+5);

      canvas.drawRect(Rect.fromPoints(a, b), paint1);

      TextSpan span = TextSpan(
        text: translated[i],
        style: const TextStyle(
          fontSize: 10,
        ),
      );
      TextPainter textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      var aText = Offset(dx1-10, dy1);
      textPainter.layout(maxWidth: 200);
      textPainter.paint(canvas, aText);

      i++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
