import 'dart:ui';

import '../model/data/point.dart';
import '../model/content/shape_data.dart';

class MiscUtils {

  static Point pathFromDataCurrentPoint = Point.empty();

  static void getPathFromData(ShapeData shapeData, Path outPath) {
    outPath.reset();

    final initialPoint = shapeData.initialPoint;
    outPath.moveTo(initialPoint.x, initialPoint.y);

    pathFromDataCurrentPoint.x = initialPoint.x;
    pathFromDataCurrentPoint.y = initialPoint.y;

    for (int i = 0; i < shapeData.curves.length; i++) {
      final curveData = shapeData.curves[i];
      final cp1 = curveData.controlPoint1;
      final cp2 = curveData.controlPoint2;
      final vert = curveData.vertex;

      if (cp1 == pathFromDataCurrentPoint && cp2 == vert) {
        outPath.lineTo(vert.x, vert.y);
      } else {
        outPath.cubicTo(cp1.x, cp1.y, cp2.x, cp2.y, vert.x, vert.y);
      }
    }

    if (shapeData.closed) {
      outPath.close();
    }
  }

}