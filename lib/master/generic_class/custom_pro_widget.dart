import 'dart:ui' as ui;

import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 20);
    path_0.cubicTo(0, 10.5719, 0, 5.85786, 2.92893, 2.92893);
    path_0.cubicTo(5.85786, 0, 10.5719, 0, 20, 0);
    path_0.lineTo(57, 0);
    path_0.lineTo(29.0278, 18.5);
    path_0.lineTo(0, 37);
    path_0.lineTo(0, 20);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff1F2F40).withOpacity(0.11);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0, 20);
    path_1.cubicTo(0, 10.5719, 0, 5.85786, 2.92893, 2.92893);
    path_1.cubicTo(5.85786, 0, 10.5719, 0, 20, 0);
    path_1.lineTo(54, 0);
    path_1.lineTo(27.5, 17.5);
    path_1.lineTo(0, 35);
    path_1.lineTo(0, 20);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
        Offset(size.width * -1.754386, size.height),
        Offset(size.width * 0.2790895, size.height * -31.67486), [
      const Color(0xffFDD239).withOpacity(1),
      const Color(0xffE59B0B).withOpacity(1)
    ], [
      0,
      1
    ]);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
