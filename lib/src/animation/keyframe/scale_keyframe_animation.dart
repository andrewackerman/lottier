import '../../value/scale_xy.dart';
import '../../value/keyframe.dart';
import './keyframe_animation.dart';

class ScaleKeyframeAnimation extends KeyframeAnimation<ScaleXY> {

  ScaleKeyframeAnimation(List<Keyframe<ScaleXY>> keyframes) : super(keyframes);

  final ScaleXY _scaleXY = ScaleXY.one();

  @override
  ScaleXY getValue(Keyframe<ScaleXY> keyframe, double keyframeProgress) {
    if (keyframe.startValue == null || keyframe.endValue == null) {
      throw StateError('Missing values for keyframes');
    }

    final startTransform = keyframe.startValue;
    final endTransform = keyframe.endValue;

    if (valueCallback != null) {
      final value = valueCallback.internalGetValue(
        keyframe.startFrame,
        keyframe.endFrame,
        startTransform,
        endTransform,
        keyframeProgress,
        linearCurrentKeyframeProgress,
        progress,
      );
      
      if (value != null) {
        return value;
      }
    }

    final newValue = ScaleXY.lerp(startTransform, endTransform, keyframeProgress);
    _scaleXY.x = newValue.x;
    _scaleXY.y = newValue.y;
    return _scaleXY;
  }

}