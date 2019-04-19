import 'dart:ui';

import 'package:lottier/src/animation/keyframe/value_callback_keyframe_animation.dart';
import 'package:lottier/src/utility/logger.dart';
import 'package:vector_math/vector_math.dart';

import './layer_base.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';
import '../../lottier_widget.dart';
import './layer.dart';
import '../../composition.dart';
import '../../utility/utility.dart';
import '../key_path.dart';
import '../../lottier_property.dart';

class CompositionLayer extends LayerBase {

  CompositionLayer(LottierRenderBox renderBox, Layer layerModel, List<Layer> layerModels, LottierComposition composition)
    : super(renderBox, layerModel) {
    final timeRemapping = layerModel.timeRemapping;
    if (timeRemapping != null) {
      _timeRemapping = timeRemapping.createAnimation();
      addAnimation(_timeRemapping);
      _timeRemapping.addUpdateListener(this);
    } else {
      _timeRemapping = null;
    }

    final layerMap = <int, LayerBase>{};

    LayerBase mattedLayer;
    for (int i = layerModels.length - 1; i >= 0; i--) {
      final lm = layerModels[i];
      final layer = LayerBase.forModel(lm, renderBox, composition);

      if (layer == null) continue;

      layerMap[layer.layerModel.layerId] = layer;

      if (mattedLayer != null) {
        mattedLayer.matteLayer = layer;
        mattedLayer = null;
      } else {
        layers[0] = layer;
        if (lm.matteType == MatteType.add || lm.matteType == MatteType.invert) {
          mattedLayer = layer;
        }
      }
    }

    for (final key in layerMap.keys) {
      final layerView = layerMap[key];

      if (layerView == null) continue;

      final parentLayer = layerMap[layerView.layerModel.parentId];
      if (parentLayer != null) {
        layerView.parentLayer = parentLayer;
      }
    }
  }

  final List<LayerBase> layers = [];

  KeyframeAnimationBase<double, double> _timeRemapping;

  var _rect = Rect.zero;
  var _newClipRect = Rect.zero;

  bool _hasMatte;
  bool _hasMasks;

  @override
  void drawLayer(Canvas canvas, Matrix3 parentMatrix, int parentAlpha) {
    Logger.beginSection('CompositionLayer#draw');
    canvas.save();

    _newClipRect = Rect.fromLTWH(0, 0, layerModel.preCompWidth.toDouble(), layerModel.preCompHeight.toDouble());
    _newClipRect = Utility.applyMatrixToRect(matrix, _newClipRect);

    for (int i = layers.length - 1; i >= 0; i--) {
      var nonEmptyClip = true;
      if (!_newClipRect.isEmpty) {
        canvas.clipRect(_newClipRect); // Flutter doesn't return whether the clip was non-empty
      }
      if (nonEmptyClip) {
        final layer = layers[i];
        layer.paint(canvas, parentMatrix, parentAlpha);
      }
    }

    canvas.restore();
    Logger.endSection('CompositionLayer#draw');
  }

  @override
  Rect getBounds(Rect bounds, Matrix3 parentMatrix, bool applyParents) {
    bounds = super.getBounds(bounds, parentMatrix, applyParents);
    for (int i = layers.length - 1; i >= 0; i--) {
      rect = Rect.zero;
      rect = layers[i].getBounds(rect, parentMatrix, true);
      bounds.expandToInclude(rect);
    }
    return bounds;
  }

  @override
  void setProgress(double progress) {
    assert(progress >= 0 && progress <= 1);

    if (_timeRemapping != null) {
      final duration = renderBox.composition.duration;
      final remappedTime = _timeRemapping.value * 1000;
      progress = remappedTime / duration;
    }

    if (layerModel.timeStretch != 0) {
      progress /= layerModel.timeStretch;
    }

    progress -= layerModel.startProgress;
    for (int i = layers.length - 1; i >= 0; i--) {
      layers[i].setProgress(progress);
    }
  }

  bool get hasMasks {
    if (_hasMasks == null) {
      for (int i = layers.length - 1; i >= 0; i--) {
        final layer = layers[i];
        if (layer is ShapeLayer) {
          if (layer.hasMasksOnThisLayer) {
            _hasMasks = true;
            return true;
          }
        } else if (layer is CompositionLayer && layer.hasMasks) {
          _hasMasks = true;
          return true;
        }
      }
      _hasMasks = false;
    }
    return _hasMasks;
  }

  bool get hasMatte {
    if (_hasMatte == null) {
      if (hasMatteOnThisLayer) {
        _hasMatte = true;
        return true;
      }

      for (int i = layers.length - 1; i >= 0; i--) {
        if (layers[i].hasMatteOnThisLayer) {
          _hasMatte = true;
          return true;
        }
      }

      _hasMatte = false;
    }
    return _hasMatte;
  }

  @override
  void resolveChildKeyPath(KeyPath keyPath, int depth, List<KeyPath> accumulator, KeyPath currentPartialKeyPath) {
    for (int i = 0; i < layers.length; i++) {
      layers[i].resolveKeyPath(keyPath, depth, accumulator, currentPartialKeyPath);
    }
  }

  @override
  void addValueCallback<T>(T property, dynamic callback) {
    super.addValueCallback(property, callback);

    if (property == LottierProperty.TimeRemap) {
      if (callback == null) {
        _timeRemapping = null;
      } else {
        _timeRemapping = ValueCallbackKeyframeAnimation.empty(callback);
        addAnimation(_timeRemapping);
      }
    }
  }


}