

import 'package:vector_math/vector_math.dart';

import './keyframe_animation_base.dart';
import './double_keyframe_animation.dart';
import '../../utility/math.dart' as Math;
import '../../value/keyframe.dart';
import '../../value/point.dart';
import '../../value/scale_xy.dart';
import '../../model/animatable/animatable_transform.dart';
import '../../model/layer/layer_base.dart';
import './value_callback_keyframe_animation.dart';
import '../../value/lottier_value_callback.dart';
import '../../lottier_property.dart';

class TransformKeyframeAnimation {

  TransformKeyframeAnimation(AnimatableTransform animatableTransform)
    : skewMatrix1 = animatableTransform.skew == null ? null : Matrix3.identity(),
      skewMatrix2 = animatableTransform.skew == null ? null : Matrix3.identity(),
      skewMatrix3 = animatableTransform.skew == null ? null : Matrix3.identity(),
      skewValues  = animatableTransform.skew == null ? null : List<double>(9) {

    _anchorPoint = animatableTransform.anchorPoint?.createAnimation();
    _position = animatableTransform.position?.createAnimation();
    _scale = animatableTransform.scale?.createAnimation();
    _rotation = animatableTransform.rotation?.createAnimation();
    _skew = animatableTransform.skew?.createAnimation();
    _skewAngle = animatableTransform.skewAngle?.createAnimation();
    _opacity = animatableTransform.opacity?.createAnimation();
    _startOpacity = animatableTransform.startOpacity?.createAnimation();
    _endOpacity = animatableTransform.endOpacity?.createAnimation();
  }

  final _matrix = Matrix3.identity();
  final Matrix3 skewMatrix1;
  final Matrix3 skewMatrix2;
  final Matrix3 skewMatrix3;
  final List<double> skewValues;

  KeyframeAnimationBase<Point, Point> _anchorPoint;
  KeyframeAnimationBase<dynamic, Point> _position;
  KeyframeAnimationBase<ScaleXY, ScaleXY> _scale;
  KeyframeAnimationBase<double, double> _rotation;
  DoubleKeyframeAnimation _skew;
  DoubleKeyframeAnimation _skewAngle;

  KeyframeAnimationBase<int, int> _opacity;
  KeyframeAnimationBase<int, int> get opacity => opacity;

  KeyframeAnimationBase<dynamic, double> _startOpacity;
  KeyframeAnimationBase<dynamic, double> get startOpacity => _startOpacity;

  KeyframeAnimationBase<dynamic, double> _endOpacity;
  KeyframeAnimationBase<dynamic, double> get endOpacity => _endOpacity;

  Matrix3 get matrix {
    _matrix.setIdentity();

    if (_position != null) {
      final position = _position.value;
      if (!position.isZero) {
        final translated = Matrix3.identity()..setColumn(2, Vector3(position.x, position.y, 1));
        matrix.multiply(translated);
      }
    }

    if (_rotation != null) {
      final rotation = _rotation.value;
      if (rotation != 0) {
        _matrix.setRotationZ(rotation);
      }
    }

    if (_skew != null) {
      final mCos = _skewAngle == null ? 0 : Math.cos(Math.toRadians(-_skewAngle.value + 90));
      final mSin = _skewAngle == null ? 1 : Math.sin(Math.toRadians(-_skewAngle.value + 90));
      final aTan = Math.tan(Math.toRadians(_skew.value));

      clearSkewValues();
      skewValues[0] = mCos;
      skewValues[1] = mSin;
      skewValues[3] = -mSin;
      skewValues[4] = mCos;
      skewValues[8] = 1;
      skewMatrix1.copyFromArray(skewValues);

      clearSkewValues();
      skewValues[0] = 1;
      skewValues[3] = aTan;
      skewValues[4] = 1;
      skewValues[8] = 1;
      skewMatrix2.copyFromArray(skewValues);

      clearSkewValues();
      skewValues[0] = mCos;
      skewValues[1] = -mSin;
      skewValues[3] = mSin;
      skewValues[4] = mCos;
      skewValues[8] = 1;
      skewMatrix3.copyFromArray(skewValues);

      skewMatrix2.multiply(skewMatrix1);
      skewMatrix3.multiply(skewMatrix2);

      matrix.multiply(skewMatrix3);
    }

    if (_scale != null) {
      final scale = _scale.value;
      if (!scale.isZero) {
        final scaled = Matrix3.zero()..setDiagonal(Vector3(scale.x, scale.y, 1));
        matrix.multiply(scaled);
      }
    }

    if (_anchorPoint != null) {
      final anchorPoint = _anchorPoint.value;
      if (!anchorPoint.isZero) {
        final translated = Matrix3.identity()..setColumn(2, Vector3(-anchorPoint.x, -anchorPoint.y, 1));
        matrix.multiply(translated);
      }
    }

    return matrix;
  }

  void addAnimationsToLayer(LayerBase layer) {
    layer.addAnimation(_opacity);
    layer.addAnimation(_startOpacity);
    layer.addAnimation(_endOpacity);

    layer.addAnimation(_anchorPoint);
    layer.addAnimation(_position);
    layer.addAnimation(_scale);
    layer.addAnimation(_rotation);
    layer.addAnimation(_skew);
    layer.addAnimation(_skewAngle);
  }

  void addListener(AnimationListener listener) {
    if (_opacity != null) {
      _opacity.addUpdateListener(listener);
    }
    if (_startOpacity != null) {
      _startOpacity.addUpdateListener(listener);
    }
    if (_endOpacity != null) {
      _endOpacity.addUpdateListener(listener);
    }
    
    if (_anchorPoint != null) {
      _anchorPoint.addUpdateListener(listener);
    }
    if (_position != null) {
      _position.addUpdateListener(listener);
    }
    if (_scale != null) {
      _scale.addUpdateListener(listener);
    }
    if (_rotation != null) {
      _rotation.addUpdateListener(listener);
    }
    if (_skew != null) {
      _skew.addUpdateListener(listener);
    }
    if (_skewAngle != null) {
      _skewAngle.addUpdateListener(listener);
    }
  }

  void setProgress(double progress) {
    if (_opacity != null) {
      _opacity.setProgress(progress);
    }
    if (_startOpacity != null) {
      _startOpacity.setProgress(progress);
    }
    if (_endOpacity != null) {
      _endOpacity.setProgress(progress);
    }
    
    if (_anchorPoint != null) {
      _anchorPoint.setProgress(progress);
    }
    if (_position != null) {
      _position.setProgress(progress);
    }
    if (_scale != null) {
      _scale.setProgress(progress);
    }
    if (_rotation != null) {
      _rotation.setProgress(progress);
    }
    if (_skew != null) {
      _skew.setProgress(progress);
    }
    if (_skewAngle != null) {
      _skewAngle.setProgress(progress);
    }
  }

  void clearSkewValues() {
    for (int i = 0; i < 9; i++) {
      skewValues[i] = 0;
    }
  }

  getMatrixForRepeater(double amount) {
    final position = _position?.value;
    final scale = _scale?.value;
    final rotation = _rotation?.value;

    _matrix.setIdentity();

    if (position != null) {
      final translated = Matrix3.identity()..setColumn(2, Vector3(position.x, position.y, 1));
      matrix.multiply(translated);
    }

    if (scale != null) {
      final scaled = Matrix3.zero()..setDiagonal(Vector3(scale.x, scale.y, 1));
      matrix.multiply(scaled);
    }
    
    if (rotation != null) {
      final anchorPoint = _anchorPoint?.value ?? Point.empty();
      final preTranslate = Matrix3.identity()..setColumn(2, Vector3(anchorPoint.x, anchorPoint.y, 1));
      final rotate = Matrix3.rotationZ(rotation);
      final postTranslate = Matrix3.identity()..setColumn(2, Vector3(-anchorPoint.x, -anchorPoint.y, 1));
      matrix.multiply(preTranslate);
      matrix.multiply(rotate);
      matrix.multiply(postTranslate);
    }

    return matrix;
  }

  bool applyValueCallback<T>(T property, LottierValueCallback<dynamic> callback) {
    if (property == LottierProperty.TransformAnchorPoint) {
      if (_anchorPoint == null) {
        _anchorPoint = new ValueCallbackKeyframeAnimation(callback, Point.empty());
      } else {
        _anchorPoint.setValueCallback(callback);
      }
    } else if (property == LottierProperty.TransformPosition) {
      if (_position == null) {
        _position = new ValueCallbackKeyframeAnimation(callback, Point.empty());
      } else {
        _position.setValueCallback(callback);
      }
    } else if (property == LottierProperty.TransformScale) {
      if (_scale == null) {
        _scale = new ValueCallbackKeyframeAnimation(callback, ScaleXY.one());
      } else {
        _scale.setValueCallback(callback);
      }
    } else if (property == LottierProperty.TransformRotation) {
      if (_rotation == null) {
        _rotation = new ValueCallbackKeyframeAnimation(callback, 0);
      } else {
        _rotation.setValueCallback(callback);
      }
    } else if (property == LottierProperty.TransformOpacity) {
      if (_opacity == null) {
        _opacity = new ValueCallbackKeyframeAnimation(callback, 100);
      } else {
        _opacity.setValueCallback(callback);
      }
    } else if (property == LottierProperty.TransformStartOpacity) {
      if (_startOpacity == null) {
        _startOpacity = new ValueCallbackKeyframeAnimation(callback, 100);
      } else {
        _startOpacity.setValueCallback(callback);
      }
    } else if (property == LottierProperty.TransformEndOpacity) {
      if (_endOpacity == null) {
        _endOpacity = new ValueCallbackKeyframeAnimation(callback, 100);
      } else {
        _endOpacity.setValueCallback(callback);
      }
    } else if (property == LottierProperty.TransformSkew) {
      if (_skew == null) {
        _skew = new DoubleKeyframeAnimation([Keyframe.nonanimated(0.0)]);
      }
      _skew.setValueCallback(callback);
    } else if (property == LottierProperty.TransformSkewAngle) {
      if (_skewAngle == null) {
        _skewAngle = new DoubleKeyframeAnimation([Keyframe.nonanimated(0.0)]);
      }
      _skewAngle.setValueCallback(callback);
    } else {
      return false;
    }

    return true;
  }
}