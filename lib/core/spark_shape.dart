import 'package:flutter/cupertino.dart';



class SparkAppBarBorder extends ShapeBorder {
  const SparkAppBarBorder();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => this;


  @override
  Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
    return Path();
  }


  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    final Path path = Path();
    path.lineTo(rect.width / 2.0, 0.0);
    path.lineTo(rect.width / 2.0 + 20.0, rect.height / 2.0 - 20.0);
    path.lineTo(rect.width, rect.height / 2.0 - 20.0);
    path.lineTo(rect.width, rect.height);
    path.lineTo(0.0, rect.height);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection? textDirection }) {
  }
}
