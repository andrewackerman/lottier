import '../animatable/animatable_shape_value.dart';
import '../animatable/animatable_integer_value.dart';

class Mask {
  final MaskMode maskMode;
  final AnimatableShapeValue maskPath;
  final AnimatableIntegerValue opacity;
  final bool inverted;

  Mask(
    this.maskMode, 
    this.maskPath,
    this.opacity,
    this.inverted,
  ) : assert(maskMode != null),
      assert(maskPath != null),
      assert(opacity != null),
      assert(inverted != null);
}

enum MaskMode {
  add,
  subtract,
  intersect,
}