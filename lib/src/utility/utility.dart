import 'dart:ui';

import '../value/point.dart';

class Utility {

  static double get pixelRatio => window.devicePixelRatio;

  static Path createPath(Point startPoint, Point endPoint, Point cp1, Point cp2) {
    final path = Path();
    path.moveTo(startPoint.x, startPoint.y);

    if (cp1 != null && cp2 != null && (cp1.lengthSqr != 0 || cp2.lengthSqr != 0)) {
      path.cubicTo(
        startPoint.x + cp1.x, startPoint.y + cp1.y, 
        endPoint.x + cp2.x, endPoint.y + cp2.y, 
        endPoint.x, endPoint.y,
      );
    } else {
      path.lineTo(endPoint.x, endPoint.y);
    }

    return path;
  }

  static Tangent getTangentForPathMetrics(PathMetrics metrics, double distance) {
    var tangents = <Tangent>[];

    for (var metric in metrics) {
      tangents.add(metric.getTangentForOffset(distance));
    }

    return tangents.reduce((sum, acc) => Tangent.fromAngle(sum.position + acc.position, acc.angle));
  }

  static bool isAtLeastVersion(int major, int minor, int patch, int minMajor, int minMinor, int minPatch) {
    if (major > minMajor) return true;
    if (major < minMajor) return false;

    if (minor > minMinor) return true;
    if (minor < minMinor) return false;

    return patch >= minPatch;
  }

}