import '../../value/keyframe.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';

abstract class AnimatableValue<K, A> {
  List<Keyframe<K>> get keyframes;
  bool get isStatic;
  KeyframeAnimationBase<K, A> createAnimation();
}