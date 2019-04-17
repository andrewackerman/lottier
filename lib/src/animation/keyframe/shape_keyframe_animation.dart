import 'dart:ui';

import '../../utility/misc.dart';
import '../../value/keyframe.dart';
import './keyframe_animation_base.dart';
import '../../model/content/shape_data.dart';

class ShapeKeyframeAnimation extends KeyframeAnimationBase<ShapeData, Path> {

  ShapeKeyframeAnimation(
    List<Keyframe<ShapeData>> keyframes
  ) : super(keyframes);

  final tempShapeData = ShapeData.empty();
  final tempPath = Path();

  @override
  Path getValue(Keyframe<ShapeData> keyframe, double keyframeProgress) {
    final startShapeData = keyframe.startValue;
    final endShapeData = keyframe.endValue;

    tempShapeData.interpolateBetween(startShapeData, endShapeData, keyframeProgress);
    MiscUtils.getPathFromData(tempShapeData, tempPath);
    return tempPath;
  }

}