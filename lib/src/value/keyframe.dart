import '../composition.dart';
import '../animation/interpolator.dart';

class Keyframe<T> {

  Keyframe(
    this.composition,
    this.startValue,
    this.endValue,
    this.interpolator,
    this.startFrame,
    this.endFrame,
  ) : assert(startFrame != null);
  
  factory Keyframe.nonanimated(T value) {
    return Keyframe(null, value, value, null, double.minPositive, double.maxFinite);
  }

  final LottierComposition composition;
  final T startValue;
  final T endValue;
  final Interpolator interpolator;
  final double startFrame;
  final double endFrame;
  
  double startValueDouble;
  double endValueDouble;

  int startValueInt;
  int endValueInt;

  double _startProgress;
  double get startProgress {
    if (composition == null) {
      return 0;
    }

    if (_startProgress == null) {
      _startProgress = (startFrame - composition.startFrame) / composition.durationFrames;
    }

    return _startProgress;
  }

  double _endProgress;
  double get endProgress {
    if (composition == null) {
      return 1;
    }

    if (_endProgress == null) {
      if (endFrame == null) {
        _endProgress = 1;
      } else {
        final durationFrames = endFrame - startFrame;
        final durationProgress = durationFrames / composition.durationFrames;
        _endProgress = startProgress + durationProgress;
      }
    }

    return _endProgress;
  }

  bool get isStatic => interpolator == null;

  bool containsProgress(double progress) {
    assert(progress >= 0 && progress <= 1);

    return progress >= startProgress && progress <= endProgress;
  }
}