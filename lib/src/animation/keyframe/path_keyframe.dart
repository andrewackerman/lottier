import 'dart:ui';

import '../interpolator.dart';
import '../../value/point.dart';
import '../../value/keyframe.dart';
import '../../composition.dart';
import '../../utility/utility.dart';

class PathKeyframe extends Keyframe<Point> {

  PathKeyframe(
    LottierComposition composition,
    Point startValue,
    Point endValue,
    Interpolator interpolator,
    double startFrame,
    double endFrame,
  ) : super(composition, startValue, endValue, interpolator, startFrame, endFrame) {
    createPath();
  }
  
  Point pathCp1;
  Point pathCp2;

  Path _path;
  Path get path => _path;

  void createPath() {
    bool equals = endValue != null && startValue != null &&
      startValue == endValue;
    
    if (endValue != null && !equals) {
      _path = Utility.createPath(startValue, endValue, pathCp1, pathCp2);
    }
  }

}