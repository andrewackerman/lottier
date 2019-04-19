import 'dart:ui';

import 'package:vector_math/vector_math.dart';

import './layer_base.dart';
import '../../lottier_widget.dart';
import './layer.dart';
import '../../utility/utility.dart';
import '../../animation/keyframe/keyframe_animation_base.dart';

class ImageLayer extends LayerBase {

  ImageLayer(LottierRenderBox renderBox, Layer layerModel)
    : super(renderBox, layerModel);

    final Paint _paint = Paint()
      ..isAntiAlias = true;

    Rect _src = Rect.zero;
    Rect _dst = Rect.zero;

    KeyframeAnimationBase<ColorFilter, ColorFilter> _colorFilterAnimation;

    @override
    void drawLayer(Canvas canvas, Matrix3 parentMatrix, int parentAlpha) {
      final image = _getImage();

      if (image == null) {
        return;
      }

      final density = Utility.dpScale;

      _paint.color = _paint.color.withAlpha(parentAlpha);
      if (_colorFilterAnimation != null) {
        _paint.colorFilter = _colorFilterAnimation.value;
      }

      canvas.save();

      List<double> nums = List(9);
      matrix.copyIntoArray(nums);
      canvas.transform(nums);

      _src = Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble());
      _dst = Rect.fromLTRB(0, 0, image.width * density, image.height * density);

      canvas.drawImageRect(image, _src, _dst, _paint);
      canvas.restore();
    }

    @override
    Rect getBounds(Rect bounds, Matrix3 parentMatrix, bool applyParents) {
      bounds = super.getBounds(bounds, parentMatrix, applyParents);

      Image image = _getImage();
      if (image != null) {
        final density = Utility.dpScale;
        bounds = Rect.fromLTRB(0, 0, image.width * density, image.height * density);
        bounds = Utility.applyMatrixToRect(boundsMatrix, bounds);
      }

      return bounds;
    }

    Image _getImage() {
      final refId = layerModel.refId;
      return renderBox.getImageAsset(refId);
    }

}