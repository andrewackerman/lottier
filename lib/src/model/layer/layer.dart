import '../content/content_model.dart';
import '../../composition.dart';

class Layer {
  final List<ContentModel> shapes;
  final LottierComposition composition;
  final String layerName;
  final int layerId;
  final LayerType layerType;
  final int parentId;
  final String refId;
  final List<Mask> masks;
  final AnimatableTransform transform;
  final int solidWidth;
  final int solidHeight;
  final int solidColor;
  final double timeStretch;
  final double startFrame;
  final int preCompWidth;
  final int preCompHeight;
  final AnimatableTextFrame text;
  final AnimatableTextProperties textProperties;
  final AnimatableFloatValue timeRemapping;
  final List<Keyframe<double>> inOutKeyframes;
  final MatteType matteType;
  final bool hidden;

  Layer({
    this.shapes,
    this.composition,
    this.layerName,
    this.layerId,
    this.layerType,
    this.parentId,
    this.refId,
    this.masks,
    this.transform,
    this.solidWidth,
    this.solidHeight,
    this.solidColor,
    this.timeStretch,
    this.startFrame,
    this.preCompWidth,
    this.preCompHeight,
    this.text,
    this.textProperties,
    this.timeRemapping,
    this.inOutKeyframes,
    this.matteType,
    this.hidden,
  }) : assert(shapes != null),
       assert(composition != null),
       assert(layerName != null),
       assert(layerId != null),
       assert(layerType != null),
       assert(parentId != null),
       assert(masks != null),
       assert(transform != null),
       assert(solidWidth != null),
       assert(solidHeight != null),
       assert(solidColor != null),
       assert(timeStretch != null),
       assert(startFrame != null),
       assert(preCompWidth != null),
       assert(preCompHeight != null),
       assert(inOutKeyframes != null),
       assert(matteType != null),
       assert(hidden != null);
}

enum LayerType {
  preComp,
  solid,
  image,
  none,
  shape,
  text,
  unknown,
}

enum MatteType {
  none,
  add,
  invert,
  unknown,
}