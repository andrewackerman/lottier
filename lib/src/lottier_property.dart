import 'dart:ui';

import './value/point.dart';
import './value/scale_xy.dart';

class LottierProperty {

  static const Color = 1;
  static const StrokeColor = 2;
  static const TransformOpacity = 3;
  static const Opacity = 4;

  static final TransformAnchorPoint = Point(0, 1); 
  static final TransformPosition = Point(0, 2);
  static final EllipseSize = Point(0, 3);
  static final RectangleSize = Point(0, 4);
  static final Position = Point(0, 5);

  static const CornerRadius = 0.0;
  static const TransformRotation = 1.0;
  static const TransformSkew = 0.0;
  static const TransformSkewAngle = 0.0;
  static const StrokeWidth = 2.0;
  static const TextTracking = 3.0;
  static const RepeaterCopies = 4.0;
  static const RepeaterOffset = 5.0;
  static const PolystarPoints = 6.0;
  static const PolystarRotation = 7.0;
  static const PolystarInnerRadius = 8.0;
  static const PolystarOuterRadius = 9.0;
  static const PolystarInnerRoundedness = 10.0;
  static const PolystarOuterRoundedness = 11.0;
  static const TransformStartOpacity = 12.0;
  static const TransformEndOpacity = 12.0;
  static const TimeRemap = 13.0;

  static final TransformScale = ScaleXY(0, 1);

  static final Color_Filter = ColorFilter.linearToSrgbGamma();

  static final GradientColor = List<int>(0);

}