import './keyframe_animation.dart';
import '../../value/keyframe.dart';
import '../../utility/math.dart' as Math;

class DoubleKeyframeAnimation extends KeyframeAnimation<double> {

  DoubleKeyframeAnimation(List<Keyframe<double>> keyframes) : super(keyframes);

  @override
  double getValue(Keyframe<double> keyframe, double keyframeProgress) {
    if (keyframe.startValue == null || keyframe.endValue == null) {
      throw StateError('Missing values for keyframes');
    }

    if (valueCallback != null) {
      final value = valueCallback.internalGetValue(
        keyframe.startFrame, 
        keyframe.endFrame, 
        keyframe.startValue, 
        keyframe.endValue, 
        keyframeProgress, 
        linearCurrentKeyframeProgress, 
        progress,
      );
      if (value != null) {
        return value;
      }
    }

    return Math.lerp(keyframe.startValue, keyframe.endValue, keyframeProgress);
  }

}