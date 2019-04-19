import 'dart:ui';

import 'package:vector_math/vector_math.dart';

abstract class PaintingContent {

  void paint(Canvas canvas, Matrix3 parentMatrix, int parentAlpha);

}