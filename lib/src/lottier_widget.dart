import 'dart:ui' as UI;

import 'package:flutter/scheduler.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import './composition.dart';

class LottierWidget extends LeafRenderObjectWidget {
  final LottierComposition composition;

  LottierWidget(this.composition);

  @override
  RenderBox createRenderObject(BuildContext cxt) {
    return LottierRenderBox(composition);
  }

  @override
  void updateRenderObject(BuildContext cxt, RenderBox renderObject) {
    final LottierRenderBox lottierBox = renderObject as LottierRenderBox;
    lottierBox.composition = composition;
  }
}

class ConstrainedLottierBox extends RenderConstrainedBox {
  LottierRenderBox lottierBox;
  Size size;

  ConstrainedLottierBox(this.lottierBox, {this.size})
    : super(
        child: lottierBox,
        additionalConstraints: BoxConstraints(
          minWidth: size.width,
          minHeight: size.height,
          maxWidth: size.width,
          maxHeight: size.height));
}

class LottierRenderBox extends RenderBox {
  LottierComposition composition;
  Duration _previous = Duration.zero;
  int _frameCallbackId;

  LottierRenderBox(this.composition);

  @override
  bool get sizedByParent => false;

  @override
  void performResize() {
    super.performResize();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scheduleTick();
  }

  @override
  void detach() {
    super.detach();
    _unscheduleTick();
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  void _tick(Duration timestamp) {
    if (!attached) return;
    _scheduleTick();
    _update(timestamp);
    markNeedsPaint();
  }

  void _update(Duration now) {
    var delta = now - _previous;
    if (_previous == Duration.zero) {
      delta = Duration.zero;
    }

    _previous = now;
    final dt = delta.inMicroseconds / Duration.microsecondsPerSecond;

    composition.update(dt);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);
    composition.paint(context.canvas);
    context.canvas.restore();
  }

  UI.Image getImageAsset(String refId) {
    if (imageAssetManager != null) {

    }
  }

  ImageAssetManager _imageAssetManager;
  ImageAssetManager get imageAssetManager {
    if (_imageAssetManager == null) {
      _imageAssetManager = new ImageAssetManager();
    }
    return _imageAssetManager;
  }
}