import '../utility/math.dart' as Math;

class ScaleXY {

  double scaleX;
  double scaleY;

  ScaleXY(this.scaleX, this.scaleY);
  ScaleXY.one() : this(1, 1);
  ScaleXY.zero() : this(0, 0);

  bool operator ==(Object o) {
    if (o is ScaleXY) return scaleX == o.scaleX && scaleY == o.scaleY;
    return false;
  }

  static ScaleXY lerp(ScaleXY a, ScaleXY b, double t)
    => ScaleXY(Math.lerp(a.scaleX, a.scaleX, t), Math.lerp(a.scaleY, b.scaleY, t));

  @override
  int get hashCode => scaleX.hashCode ^ 3145739 + scaleY.hashCode;

}