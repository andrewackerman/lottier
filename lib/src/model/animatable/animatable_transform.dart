import '../../animation/content/content.dart';
import '../layer/layer_base.dart';
import '../../animation/content/modifier_content.dart';
import '../content/content_model.dart';
import '../../model/data/point.dart';
import './animatable_value.dart';
import './animatable_path_value.dart';
import './animatable_scale_value.dart';
import './animatable_double_value.dart';
import './animatable_integer_value.dart';

class AnimatableTransform implements ModifierContent, ContentModel {

  AnimatableTransform(
    this.anchorPoint,
    this.position,
    this.scale,
    this.rotation,
    this.opacity,
    this.skew,
    this.skewAngle,
  );

  final AnimatablePathValue anchorPoint;
  final AnimatableValue<Point, Point> position;
  final AnimatableScaleValue scale;
  final AnimatableDoubleValue rotation;
  final AnimatableIntegerValue opacity;
  final AnimatableDoubleValue skew;
  final AnimatableDoubleValue skewAngle;

  AnimatableDoubleValue _startOpacity;
  AnimatableDoubleValue get startOpacity => _startOpacity;
  
  AnimatableDoubleValue _endOpacity;
  AnimatableDoubleValue get endOpacity => _endOpacity;

  TransformKeyframeAnimation createAnimation() => TransformKeyframeAnimation(this);

  @override
  Content toContent(LayerBase layer) => null;

}