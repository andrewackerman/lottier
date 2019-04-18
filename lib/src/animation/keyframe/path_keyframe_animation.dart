import 'dart:ui';

import './keyframe_animation.dart';
import '../../value/point.dart';
import '../../value/keyframe.dart';
import './path_keyframe.dart';
import '../../utility/utility.dart';

class PathKeyframeAnimation extends KeyframeAnimation<Point> {

  PathKeyframeAnimation(List<Keyframe<Point>> keyframes) : super(keyframes);

  final _point = Point.empty();
  PathKeyframe _pathMeasureKeyframe;
  PathMetrics _pathMeasure;

  @override
  Point getValue(Keyframe<Point> keyframe, double keyframeProgress) {
    final pathKeyframe = keyframe as PathKeyframe;
    final path = pathKeyframe.path;

    if (path == null) {
      return keyframe.startValue;
    }

    if (valueCallback != null) {
      final value = valueCallback.internalGetValue(
        pathKeyframe.startFrame,
        pathKeyframe.endFrame,
        pathKeyframe.startValue,
        pathKeyframe.endValue,
        linearCurrentKeyframeProgress,
        keyframeProgress,
        progress,
      );
      if (value != null) {
        return value;
      }
    }

    if (_pathMeasureKeyframe != pathKeyframe) {
      _pathMeasure = path.computeMetrics();
      _pathMeasureKeyframe = pathKeyframe;
    }

    final tangent = Utility.getTangentForPathMetrics(_pathMeasure, keyframeProgress * _pathMeasure.length);
    _point.x = tangent.position.dx;
    _point.y = tangent.position.dy;
    return _point;
  }

}