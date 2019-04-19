import 'dart:ui';

import './keyframe_animation_base.dart';
import '../../model/content/shape_data.dart';
import '../../model/content/mask.dart';

class MaskKeyframeAnimation {

  MaskKeyframeAnimation(this.masks)
    : this.maskAnimations = List(masks.length),
      this.opacityAnimations = List(masks.length) {
    for (int i = 0; i < masks.length; i++) {
      maskAnimations[i] = masks[i].maskPath.createAnimation();
      opacityAnimations[i] = masks[i].opacity.createAnimation();
    }
  }

  final List<KeyframeAnimationBase<ShapeData, Path>> maskAnimations;
  final List<KeyframeAnimationBase<int, int>> opacityAnimations;
  final List<Mask> masks;

}