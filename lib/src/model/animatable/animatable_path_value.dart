import '../../animation/keyframe/point_keyframe_animation.dart';
import '../../animation/keyframe/path_keyframe_animation.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';
import './animatable_value.dart';
import '../../value/point.dart';
import '../../value/keyframe.dart';

class AnimatablePathValue implements AnimatableValue<Point, Point> {

  final List<Keyframe<Point>> keyframes;

  AnimatablePathValue(this.keyframes);
  AnimatablePathValue.empty() : this([Keyframe.nonanimated(Point.empty())]);

  @override
  bool get isStatic => keyframes.length == 1 && keyframes[0].isStatic;
  
  @override
  KeyframeAnimationBase<Point, Point> createAnimation() {
    if (keyframes[0].isStatic) {
      return PointKeyframeAnimation(keyframes);
    }
    
    return PathKeyframeAnimation(keyframes);
  }

}