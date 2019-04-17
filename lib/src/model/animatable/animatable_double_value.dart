import '../../animation/keyframe/keyframe_animation_base.dart';
import '../../animation/keyframe/double_keyframe_animation.dart';
import './animatable_value_base.dart';
import '../../value/keyframe.dart';

class AnimatableDoubleValue extends AnimatableValueBase<double, double> {
  
  AnimatableDoubleValue(List<Keyframe<double>> keyframes) : super(keyframes);
  AnimatableDoubleValue.empty() : super.value(0);

  @override
  KeyframeAnimationBase<double, double> createAnimation() {
    return DoubleKeyframeAnimation(keyframes);;
  }

}