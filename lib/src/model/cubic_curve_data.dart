import './data/point.dart';

class CubicCurveData {
  Point controlPoint1;
  Point controlPoint2;
  Point vertex;

  CubicCurveData(
    this.controlPoint1,
    this.controlPoint2,
    this.vertex,
  );
  
  CubicCurveData.empty() : this(Point.empty(), Point.empty(), Point.empty());
}