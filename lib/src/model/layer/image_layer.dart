import 'dart:ui';

import 'package:vector_math/vector_math.dart';

import './layer_base.dart';
import '../../lottier_widget.dart';
import './layer.dart';
import '../../utility/utility.dart';

class ImageLayer extends LayerBase {

  ImageLayer(LottierRenderBox renderBox, Layer layerModel)
    : super(renderBox, layerModel);

    final Paint _paint = Paint()
      ..isAntiAlias = true;

    Rect _src = Rect.zero;
    Rect _dst = Rect.zero;

    @override
    void drawLayer(Canvas canvas, Matrix3 parentMatrix, int parentAlpha) {
      final image = _getImage();

      if (image == null) {
        return;
      }

      final density = Utility.dpScale;

      _paint.color = _paint.color.withAlpha(parentAlpha);
      if (colorFilterAnimation != null)

      canvas.drawImageRect(image, _src, _dst, _paint);
      canvas.restore();
    }

    Image _getImage() {
      final refId = layerModel.refId;
      return renderBox.getImageAsset(refId);
    }

}