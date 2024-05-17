import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../general_utils/app_dimens.dart';

class RPSCustomPainter extends CustomPainter {
  Color color;

  RPSCustomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    paint0Stroke.color = const Color(0xffE6E6E6).withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.005263158, size.height * 0.005263158,
                size.width * 0.9894737, size.height * 0.9894737),
            bottomRight: Radius.circular(size.width * 0.2578947),
            bottomLeft: Radius.circular(size.width * 0.2578947),
            topLeft: Radius.circular(size.width * 0.2578947),
            topRight: Radius.circular(size.width * 0.2578947)),
        paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color.withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.005263158, size.height * 0.005263158,
                size.width * 0.9894737, size.height * 0.9894737),
            bottomRight: Radius.circular(size.width * 0.2578947),
            bottomLeft: Radius.circular(size.width * 0.2578947),
            topLeft: Radius.circular(size.width * 0.2578947),
            topRight: Radius.circular(size.width * 0.2578947)),
        paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RectangleShapeWithIcon extends StatelessWidget {
  const RectangleShapeWithIcon({
    Key? key,
    //required this.svgPath,
    this.shapeColor,
    required this.centerWidget,
  }) : super(key: key);

  //final String svgPath;
  final Widget centerWidget;
  final Color? shapeColor;
  //final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: const Size(
              AppDimens.shapeSize,
              AppDimens
                  .shapeSize), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
          painter: RPSCustomPainter(
              color: shapeColor ?? Get.theme.colorScheme.primary),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: centerWidget,
          ),
        )
      ],
    );
  }
}
