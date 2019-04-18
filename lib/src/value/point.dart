import 'dart:ui';

import '../utility/math.dart' as Math;

class Point {
  double x;
  double y;

  Point(this.x, this.y);
  Point.empty() : this(0, 0);
  Point.copy(Point p) : this(p.x, p.y);
  Point.fromOffset(Offset o) : this(o.dx, o.dy);

  double get lengthSqr => x * x + y * y;
  double get length => Math.sqrt(lengthSqr);
  bool get isZero => x == 0 && y == 0;

  bool operator ==(Object o) {
    if (o is Point) return x == o.x && y == o.y;
    return false;
  }

  Point operator +(Point p) => Point(x + p.x, y + p.y);
  Point operator -(Point p) => Point(x - p.x, y + p.y);

  static Point lerp(Point a, Point b, double t)
    => Point(Math.lerp(a.x, a.y, t), Math.lerp(a.y, b.y, t));

  @override
  int get hashCode => x.hashCode ^ 3145739 + y.hashCode;
}