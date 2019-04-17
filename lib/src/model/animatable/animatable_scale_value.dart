import './animatable_value_base.dart';
import '../../value/keyframe.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';
import '../../animation/keyframe/scale_keyframe_animation.dart';
import '../../value/scale_xy.dart';

class AnimatableScaleValue extends AnimatableValueBase<ScaleXY, ScaleXY> {

  AnimatableScaleValue(List<Keyframe<ScaleXY>> keyframes) : super(keyframes);
  AnimatableScaleValue.empty() : this([Keyframe.nonanimated(ScaleXY.one())]);
  AnimatableScaleValue.value(ScaleXY value) : this([Keyframe.nonanimated(value)]);

  @override
  KeyframeAnimationBase<ScaleXY, ScaleXY> createAnimation() {
    return ScaleKeyframeAnimation(keyframes);
  }

}