

import './keyframe_animation.dart';
import '../../value/point.dart';
import '../../value/keyframe.dart';

class PointKeyframeAnimation extends KeyframeAnimation<Point> {

  Point _point = Point.empty();

  PointKeyframeAnimation(List<Keyframe<Point>> keyframes) : super(keyframes);

  @override
  Point getValue(Keyframe<Point> keyframe, double keyframeProgress) {
    if (keyframe.startValue == null || keyframe.endValue == null) {
      throw StateError('Missing values for keyframe.');
    }

    final startPoint = keyframe.startValue;
    final endPoint = keyframe.endValue;

    if (valueCallback != null) {
      final value = valueCallback.internalGetValue(
        keyframe.startFrame,
        keyframe.endFrame,
        startPoint,
        endPoint,
        keyframeProgress,
        linearCurrentKeyframeProgress,
        progress,
      );

      if (value != null) {
        return value;
      }
    }

    _point = Point.lerp(startPoint, endPoint, keyframeProgress);
    return _point;
  }

}