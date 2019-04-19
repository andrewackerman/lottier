import '../../value/keyframe.dart';
import './keyframe_animation.dart';
import '../../utility/math.dart' as Math;
import '../../utility/gamma_evaluator.dart';

class ColorKeyframeAnimation extends KeyframeAnimation<int> {

  ColorKeyframeAnimation(List<Keyframe<int>> keyframes) : super(keyframes);

  @override
  int getValue(Keyframe<int> keyframe, double keyframeProgress) {
    if (keyframe.startValue == null || keyframe.endValue == null) {
      throw StateError('Missing values for keyframe.');
    }

    final startValue = keyframe.startValue;
    final endValue = keyframe.endValue;

    if (valueCallback != null) {
      final value = valueCallback.internalGetValue(
        keyframe.startFrame, 
        keyframe.endFrame, 
        startValue, 
        endValue, 
        keyframeProgress, 
        linearCurrentKeyframeProgress, 
        progress,
      );
      if (value != null) {
        return value;
      }
    }

    return GammaEvaluator.evaluate(Math.clamp(keyframeProgress, 0, 1), startValue, endValue);
  }

}