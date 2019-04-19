import 'dart:typed_data';
import 'dart:ui';

import 'package:vector_math/vector_math.dart';

import '../content/shape_data.dart';
import '../../animation/content/painting_content.dart';
import './layer.dart';
import '../../lottier_widget.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';
import '../../animation/keyframe/transform_keyframe_animation.dart';
import '../../utility/logger.dart';
import '../../composition.dart';
import '../../animation/keyframe/mask_keyframe_animation.dart';
import '../../animation/keyframe/double_keyframe_animation.dart';
import '../content/mask.dart';
import '../../utility/math.dart' as Math;
import '../../animation/content/content.dart';
import '../key_path.dart';
import '../key_path_element.dart';

const _ClipSaveFlag = 0x02;
const _ClipToLayerSaveFlag = 0x10;
const _MatrixSaveFlag = 0x01;
const _SaveFlags = _ClipSaveFlag | _ClipToLayerSaveFlag | _MatrixSaveFlag;

abstract class LayerBase implements PaintingContent, AnimationListener, KeyPathElement {

  LayerBase(this.renderBox, this.layerModel) {
    drawTraceName = layerModel.layerName + '#draw';

    // TODO
    // if (layerModel.getMatteType() == Layer.MatteType.INVERT) {
    //   mattePaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.DST_OUT));
    // } else {
    //   mattePaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.DST_IN));
    // }

    transform = layerModel.transform.createAnimation();
    transform.addListener(this);

    if (layerModel.masks != null && layerModel.masks.isNotEmpty) {
      mask = MaskKeyframeAnimation(layerModel.masks);
      for (var animation in mask.maskAnimations) {
        animation.addUpdateListener(this);
      }
      for (var animation in mask.opacityAnimations) {
        animation.addUpdateListener(this);
      }
    }

    setupInOutAnimations();
  }

  Paint _contentPaint = Paint()
    ..isAntiAlias = true;
  Paint _dstInPaint = Paint()
    ..isAntiAlias = true 
    ..blendMode = BlendMode.dstIn;
  Paint _dstOutPaint = Paint()
    ..isAntiAlias = true
    ..blendMode = BlendMode.dstOut;
  Paint _mattePaint = Paint()
    ..isAntiAlias = true;
  Paint _clearPaint = Paint()
    ..blendMode = BlendMode.clear;
  Paint _subtractPaint = Paint()
    ..color = Color(0xFF000000);

  Path path;
  Matrix3 matrix;
  Rect rect;
  Rect maskBoundsRect;
  Rect matteBoundsRect;
  Rect tempMaskBoundsRect;
  String drawTraceName;

  Matrix3 boundsMatrix;
  LottierRenderBox renderBox;
  Layer layerModel;

  MaskKeyframeAnimation mask;
  LayerBase matteLayer;

  LayerBase parentLayer;
  List<LayerBase> parentLayers;

  final List<KeyframeAnimationBase> animations = [];
  TransformKeyframeAnimation transform;
  bool visible = true;

  bool get hasMasksOnThisLayer => mask != null && mask.maskAnimations.isNotEmpty; 
  bool get hasMatteOnThisLayer => matteLayer != null;

  static LayerBase forModel(Layer layerModel, LottierRenderBox renderBox, LottierComposition composition) {
    switch (layerModel.layerType) {
      case LayerType.shape:
        return ShapeLayer(renderBox, layerModel);
      case LayerType.preComp:
        return CompositionLayer(renderBox, layerModel, composition.precompsForId(layerModel.refId), composition);
      case LayerType.solid:
        return SolidLayer(renderBox, layerModel);
      case LayerType.image:
        return ImageLayer(renderBox, layerModel);
      case LayerType.none:
        return NullLayer(renderBox, layerModel);
      case LayerType.text:
        return TextLayer(renderBox, layerModel);
      case LayerType.unknown:
      default:
        Logger.warn('Unknown layer type ${layerModel.layerType}');
    }

    return null;
  }

  @override
  void onValueChanged() {
    invalidateSelf();
  }

  void setupInOutAnimations() {
    if (layerModel.inOutKeyframes.isNotEmpty) {
      final inOutAnimation = DoubleKeyframeAnimation(layerModel.inOutKeyframes);
      inOutAnimation.makeDiscrete();
      inOutAnimation.addUpdateListener(SimpleAnimationListener(() {
        _setVisible(inOutAnimation.value == 1);
      }));
      _setVisible(inOutAnimation.value == 1);
      addAnimation(inOutAnimation);
    } else {
      _setVisible(true);
    }
  }

  void invalidateSelf() {
    renderBox.markNeedsPaint();
  }

  void saveLayer(Canvas canvas, Rect rect, Paint paint, bool all) {
    canvas.saveLayer(rect, paint);
  }

  void addAnimation(KeyframeAnimationBase animation) {
    if (animation == null) return;
    animations.add(animation);
  }

  void removeAnimation(KeyframeAnimationBase animation) {
    animations.remove(animation);
  }

  Rect getBounds(Rect bounds, Matrix3 parentMatrix, bool applyParents) {
    rect = Rect.zero;
    _buildParentLayerListIfNeeded();

    boundsMatrix.setFrom(parentMatrix);

    if (applyParents) {
      if (parentLayers != null) {
        for (int i = 0; i < parentLayers.length; i++) {
          boundsMatrix.multiply(parentLayers[i].transform.matrix);
        }
      } else if (parentLayer != null) {
        boundsMatrix.multiply(parentLayer.transform.matrix);
      }
    }

    boundsMatrix.multiply(transform.matrix);

    return bounds;
  }

  @override
  void paint(Canvas canvas, Matrix3 parentMatrix, int parentAlpha) {
    // TODO: implement paint
  }

  void _recordRenderTime(double ms) {
    renderBox.composition.performanceTracker.recordRenderTime(layerModel.layerName, ms);
  }

  void _clearCanvas(Canvas canvas) {
    Logger.beginSection('Layer#clearLayer');
    canvas.drawRect(Rect.fromLTRB(rect.left - 1, rect.top - 1, rect.right + 1, rect.bottom + 1), _clearPaint);
    Logger.endSection('Layer#clearLayer');
  }

  Rect _intersectBoundsWithMask(Rect rect, Matrix3 matrix) {
    maskBoundsRect = Rect.fromLTRB(0, 0, 0, 0);
    if (!_hasMasksOnThisLayer) {
      return rect;
    }

    int length = mask.masks.length;
    for (int i = 0; i < length; i++) {
      final mask = this.mask.masks[i];
      final maskAnimation = this.mask.maskAnimations[i];
      final maskPath = maskAnimation.value;

      switch (mask.maskMode) {
        case MaskMode.subtract:
          return rect;
          
        case MaskMode.intersect:
        case MaskMode.add:
          if (mask.inverted) return rect;
          continue other;
        
        other:
        default:
          tempMaskBoundsRect = path.getBounds();

          if (i == 0) {
            maskBoundsRect = tempMaskBoundsRect;
          } else {
            maskBoundsRect.expandToInclude(tempMaskBoundsRect);
          }
      }
    }

    final intersect = rect.intersect(maskBoundsRect);

    if (intersect.isEmpty) {
       return Rect.zero;
    }

    return intersect;
  }

  Rect _intersectBoundsWithMatte(Rect rect, Matrix3 matrix) {
    if (!_hasMatteOnThisLayer) {
      return rect;
    }

    if (layerModel.matteType == MatteType.invert) {
      return rect;
    }

    matteBoundsRect = Rect.zero;
    matteBoundsRect = matteLayer.getBounds(matteBoundsRect, matrix, true);

    final intersect = rect.intersect(matteBoundsRect);

    if (intersect.isEmpty) {
       return Rect.zero;
    }

    return intersect;
  }

  void drawLayer(Canvas canvas, Matrix3 parentMatrix, int parentAlpha);
  
  void _applyMasks(Canvas canvas, Matrix3 matrix) {
    Logger.beginSection('Layer#saveLayer');
    saveLayer(canvas, rect, _dstInPaint, false);
    Logger.endSection('Layer#saveLayer');

    for (int i = 0; i < mask.masks.length; i++) {
      final mask = this.mask.masks[i];
      final maskAnimation = this.mask.maskAnimations[i];
      final opacityAnimation = this.mask.opacityAnimations[i];
      switch(mask.maskMode) {
        case MaskMode.add:
          if (mask.inverted) {
            _applyInvertedAddMask(canvas, matrix, mask, maskAnimation, opacityAnimation);
          } else {
            _applyAddMask(canvas, matrix, mask, maskAnimation, opacityAnimation);
          }
          break;

        case MaskMode.subtract:
          if (i == 0) {
            canvas.drawRect(rect, _subtractPaint);
          }
          if (mask.inverted) {
            _applyInvertedSubtractMask(canvas, matrix, mask, maskAnimation, opacityAnimation);
          } else {
            _applySubtractMask(canvas, matrix, mask, maskAnimation, opacityAnimation);
          }
          break;

        case MaskMode.intersect:
          if (mask.inverted) {
            _applyInvertedIntersectMask(canvas, matrix, mask, maskAnimation, opacityAnimation);
          } else {
            _applyIntersectMask(canvas, matrix, mask, maskAnimation, opacityAnimation);
          }
          break;
      }
    }

    Logger.beginSection('Layer#restoreLayer');
    canvas.restore();
    Logger.endSection('Layer#restoreLayer');
  }

  void _applyAddMask(Canvas canvas, Matrix3 matrix, Mask mask, KeyframeAnimationBase<ShapeData, Path> maskAnimation, KeyframeAnimationBase<int, int> opacityAnmiation) {
    final maskPath = maskAnimation.value;
    path = maskPath;

    List<double> nums = List(9);
    matrix.copyIntoArray(nums);
    path.transform(Float64List.fromList(nums));

    _contentPaint.color = _contentPaint.color.withAlpha((opacityAnmiation.value * 2.55).round());
    canvas.drawPath(path, _contentPaint);
  }

  void _applyInvertedAddMask(Canvas canvas, Matrix3 matrix, Mask mask, KeyframeAnimationBase<ShapeData, Path> maskAnimation, KeyframeAnimationBase<int, int> opacityAnmiation) {
    saveLayer(canvas, rect, _contentPaint, true);
    canvas.drawRect(rect, _contentPaint);

    final maskPath = maskAnimation.value;
    path = maskPath;

    List<double> nums = List(9);
    matrix.copyIntoArray(nums);
    path.transform(Float64List.fromList(nums));

    _contentPaint.color = _contentPaint.color.withAlpha((opacityAnmiation.value * 2.55).round());
    canvas.drawPath(path, _dstOutPaint);

    canvas.restore();
  }

  void _applySubtractMask(Canvas canvas, Matrix3 matrix, Mask mask, KeyframeAnimationBase<ShapeData, Path> maskAnimation, KeyframeAnimationBase<int, int> opacityAnmiation) {
    final maskPath = maskAnimation.value;
    path = maskPath;

    List<double> nums = List(9);
    matrix.copyIntoArray(nums);
    path.transform(Float64List.fromList(nums));

    canvas.drawPath(path, _dstOutPaint);
  }

  void _applyInvertedSubtractMask(Canvas canvas, Matrix3 matrix, Mask mask, KeyframeAnimationBase<ShapeData, Path> maskAnimation, KeyframeAnimationBase<int, int> opacityAnmiation) {
    saveLayer(canvas, rect, _dstOutPaint, true);
    canvas.drawRect(rect, _contentPaint);

    _dstOutPaint.color = _dstOutPaint.color.withAlpha((opacityAnmiation.value * 2.55).round());

    final maskPath = maskAnimation.value;
    path = maskPath;

    List<double> nums = List(9);
    matrix.copyIntoArray(nums);
    path.transform(Float64List.fromList(nums));

    canvas.drawPath(path, _dstOutPaint);

    canvas.restore();
  }

  void _applyIntersectMask(Canvas canvas, Matrix3 matrix, Mask mask, KeyframeAnimationBase<ShapeData, Path> maskAnimation, KeyframeAnimationBase<int, int> opacityAnmiation) {
    saveLayer(canvas, rect, _dstInPaint, true);

    final maskPath = maskAnimation.value;
    path = maskPath;

    List<double> nums = List(9);
    matrix.copyIntoArray(nums);
    path.transform(Float64List.fromList(nums));

    _contentPaint.color = _contentPaint.color.withAlpha((opacityAnmiation.value * 2.55).round());
    canvas.drawPath(path, _contentPaint);

    canvas.restore();
  }

  void _applyInvertedIntersectMask(Canvas canvas, Matrix3 matrix, Mask mask, KeyframeAnimationBase<ShapeData, Path> maskAnimation, KeyframeAnimationBase<int, int> opacityAnmiation) {
    saveLayer(canvas, rect, _dstInPaint, true);
    canvas.drawRect(rect, _contentPaint);

    _dstOutPaint.color = _dstOutPaint.color.withAlpha((opacityAnmiation.value * 2.55).round());

    final maskPath = maskAnimation.value;
    path = maskPath;

    List<double> nums = List(9);
    matrix.copyIntoArray(nums);
    path.transform(Float64List.fromList(nums));

    canvas.drawPath(path, _dstOutPaint);

    canvas.restore();
  }

  void _setVisible(bool visible) {
    if (visible != this.visible) {
      this.visible = visible;
      invalidateSelf();
    }
  }

  void setProgress(double progress) {
    assert(progress >= 0 && progress <= 1);

    transform.setProgress(progress);

    if (mask != null) {
      for (int i = 0; i < mask.maskAnimations.length; i++) {
        mask.maskAnimations[i].setProgress(progress);
      }
    }

    if (layerModel.timeStretch != 0) {
      progress /= layerModel.timeStretch;
    }

    if (matteLayer != null) {
      final matteTimeStretch = matteLayer.layerModel.timeStretch;
      matteLayer.setProgress(progress * matteTimeStretch);
    }

    for (int i = 0; i < animations.length; i++) {
      animations[i].setProgress(progress);
    }
  }

  void _buildParentLayerListIfNeeded() {
    if (parentLayers != null) {
      return;
    }

    parentLayers = [];

    if (parentLayer != null) {
      return;
    }

    var layer = parentLayer;
    while (layer != null) {
      parentLayers.add(layer);
      layer = layer.parentLayer;
    }
  }

  @override
  String get name => layerModel.layerName;

  @override
  void setContents(List<Content> contentsBefore, List<Content> contentsAfter) {}

  @override
  void resolveKeyPath(KeyPath keyPath, int depth, List<KeyPath> accumulator, KeyPath currentPartialKeyPath) {
    if (!keyPath.matches(name, depth)) {
      return;
    }

    if (name != '__container') {
      currentPartialKeyPath = currentPartialKeyPath.addKey(name);

      if (keyPath.fullyResolvesTo(name, depth)) {
        accumulator.add(currentPartialKeyPath.resolve(this));
      }
    }

    if (keyPath.propagateToChildren(name, depth)) {
      int newDepth = depth + keyPath.incrementDepthBy(name, depth);
      resolveChildKeyPath(keyPath, newDepth, accumulator, currentPartialKeyPath);
    }
  }

  resolveChildKeyPath(KeyPath keyPath, int depth, List<KeyPath> accumulator, KeyPath currentPartialKeyPath) {}

  @override
  void addValueCallback<T>(T property, dynamic callback) {
    transform.applyValueCallback(property, callback);
  }

}