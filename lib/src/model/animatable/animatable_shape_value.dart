import 'dart:ui';

import './animatable_value_base.dart';
import '../../value/keyframe.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';
import '../content/shape_data.dart';
import '../../animation/keyframe/shape_keyframe_animation.dart';

class AnimatableShapeValue extends AnimatableValueBase<ShapeData, Path> {

  AnimatableShapeValue(List<Keyframe<ShapeData>> keyframes)
    : super(keyframes);

  @override
  KeyframeAnimationBase<ShapeData, Path> createAnimation() {
    return ShapeKeyframeAnimation(keyframes);
  }

}