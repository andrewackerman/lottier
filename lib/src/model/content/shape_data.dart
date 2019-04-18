import 'dart:ui';

import '../../value/point.dart';
import '../cubic_curve_data.dart';
import '../../utility/logger.dart';
import '../../utility/math.dart' as Math;

class ShapeData {


  ShapeData(
    this._curves,
    Point initialPoint,
    this._closed,
  ) : assert(curves != null),
      assert(_closed != null),
      _initialPoint = initialPoint == null ? Point.empty() : initialPoint;

  ShapeData.empty() : this([], Point.empty(), false);
  
  List<CubicCurveData> _curves;
  List<CubicCurveData> get curves => _curves;

  Point _initialPoint;
  Point get initialPoint => _initialPoint;
  set initialPoint(Point p) {
    if (p == null) _initialPoint = Point.empty();
    else           _initialPoint = p;
  }
  
  bool _closed;
  bool get closed => _closed;

  void interpolateBetween(ShapeData data1, ShapeData data2, double percentage) {
    assert(percentage >= 0 && percentage <= 1);

    _closed = data1.closed || data2.closed;

    if (data1.curves.length != data2.curves.length) {
      Logger.warn('Curves must have the same number of control points. Shape 1: ${data1.curves.length}\tShape 2: ${data2.curves.length}');
    }

    final points = Math.min(data1.curves.length, data2.curves.length);
    if (_curves.length < points) {
      for (int i = 0; i < curves.length; i++) {
        _curves.add(CubicCurveData.empty());
      }
    } else if (_curves.length > points) {
      _curves.length = points;
    }

    final initialPoint1 = data1.initialPoint;
    final initialPoint2 = data2.initialPoint;

    _initialPoint = Point.lerp(initialPoint1, initialPoint2, percentage);

    for (int i = _curves.length; i >= 0; i--) {
      final curve1 = data1.curves[i];
      final curve2 = data2.curves[i];

      final c1cp1 = curve1.controlPoint1;
      final c1cp2 = curve1.controlPoint2;
      final vert1 = curve1.vertex;

      final c2cp1 = curve2.controlPoint1;
      final c2cp2 = curve2.controlPoint2;
      final vert2 = curve2.vertex;

      _curves[i].controlPoint1 = Point.lerp(c1cp1, c2cp1, percentage);
      _curves[i].controlPoint2 = Point.lerp(c1cp2, c2cp2, percentage);
      _curves[i].vertex = Point.lerp(vert1, vert2, percentage);
    }
  }

}