import './animatable_color_value.dart';
import './animatable_double_value.dart';

class AnimatableTextProperties {

  AnimatableTextProperties(
    this.color,
    this.stroke,
    this.strokeWidth,
    this.tracking,
  );

  final AnimatableColorValue color;
  final AnimatableColorValue stroke;
  final AnimatableDoubleValue strokeWidth;
  final AnimatableDoubleValue tracking;

}