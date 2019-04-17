import '../../utility/math.dart' as Math;
import './keyframe_animation.dart';
import '../../value/keyframe.dart';

class IntegerKeyframeAnimation extends KeyframeAnimation<int> {

  IntegerKeyframeAnimation(List<Keyframe<int>> keyframes) 
    : super(keyframes);

  @override
  int getValue(Keyframe<int> keyframe, double keyframeProgress) {
    if (keyframe.startValue == null || keyframe.endValue == null) {
      throw StateError('Missing values for keyframes');
    }

    if (valueCallback != null) {
      int value = valueCallback.internalGetValue(
        keyframe.startFrame,
        keyframe.endFrame,
        keyframe.startValue,
        keyframe.endValue,
        keyframeProgress,
        interpolatedCurrentKeyframeProgress,
        progress,
      );
      if (value != null) {
        return value;
      }
    }

    return Math.lerpInt(keyframe.startValue, keyframe.endValue, keyframeProgress);
  }

}