import '../utility/math.dart' as Math;

class ScaleXY {

  double x;
  double y;

  ScaleXY(this.x, this.y);
  ScaleXY.one() : this(1, 1);
  ScaleXY.zero() : this(0, 0);
  
  bool get isZero => x == 0 && y == 0;

  bool operator ==(Object o) {
    if (o is ScaleXY) return x == o.x && y == o.y;
    return false;
  }

  static ScaleXY lerp(ScaleXY a, ScaleXY b, double t)
    => ScaleXY(Math.lerp(a.x, a.x, t), Math.lerp(a.y, b.y, t));

  @override
  int get hashCode => x.hashCode ^ 3145739 + y.hashCode;

}