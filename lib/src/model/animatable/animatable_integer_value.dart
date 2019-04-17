import './animatable_value_base.dart';
import '../../value/keyframe.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';
import '../../animation/keyframe/integer_keyframe_animation.dart';

class AnimatableIntegerValue extends AnimatableValueBase<int, int> {

  AnimatableIntegerValue(List<Keyframe<int>> keyframes) : super(keyframes);
  AnimatableIntegerValue.empty() : super.value(100);

  @override
  KeyframeAnimationBase<int, int> createAnimation() {
    return IntegerKeyframeAnimation(keyframes);
  }

}