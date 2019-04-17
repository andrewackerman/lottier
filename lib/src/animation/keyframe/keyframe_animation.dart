import './keyframe_animation_base.dart';
import '../../value/keyframe.dart';

abstract class KeyframeAnimation<T> extends KeyframeAnimationBase<T, T> {
  KeyframeAnimation(List<Keyframe<T>> keyframes) : super(keyframes);
}