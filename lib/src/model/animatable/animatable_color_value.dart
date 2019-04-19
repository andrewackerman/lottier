import './animatable_value_base.dart';
import '../../value/keyframe.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';
import '../../animation/keyframe/color_keyframe_animation.dart';

class AnimatableColorValue extends AnimatableValueBase<int, int> {

  AnimatableColorValue(List<Keyframe<int>> keyframes) : super(keyframes);

  @override
  KeyframeAnimationBase<int, int> createAnimation() => ColorKeyframeAnimation(keyframes);

}