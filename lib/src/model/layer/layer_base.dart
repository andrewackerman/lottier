import 'dart:ui';

import 'package:vector_math/vector_math.dart';

import '../../animation/content/painting_content.dart';
import './layer.dart';
import '../../lottier_widget.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';
import '../../animation/keyframe/transform_keyframe_animation.dart';

abstract class LayerBase implements PaintingContent {

  Path _path;
  Matrix3 _matrix;
  Rect _rect;
  Rect _maskBoundsRect;
  Rect _matteBoundsRect;
  Rect _tempMaskBoundsRect;
  String _drawTraceName;

  Matrix3 boundsMatrix;
  LottierRenderBox renderBox;
  Layer layerModel;

  MaskKeyframeAnimation _mask;
  LayerBase _matteLayer;

  LayerBase _parentLayer;
  List<LayerBase> _parentLayers;

  final List<KeyframeAnimationBase<dynamic, dynamic>> _animations = [];
  TransformKeyframeAnimation transform;
  bool _visible = true;

  LayerBase(LottierRenderBox renderBox, Layer layerModel) {
    this.renderBox = renderBox;
    this.layerModel = layerModel;

    _drawTraceName = layerModel.name + '#draw';
  }
  
}