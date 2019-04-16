

class LottierFrameInfo<T> {

  LottierFrameInfo<T> set(
    double startFrame,
    double endFrame,
    T startValue,
    T endValue,
    double linearKeyframeProgress,
    double interpolatedKeyframeProgress,
    double overallProgress,
  ) {
    _startFrame = startFrame;
    _endFrame = endFrame;
    _startValue = startValue;
    _endValue = endValue;
    _linearKeyframeProgress = linearKeyframeProgress;
    _interpolatedKeyframeProgress = interpolatedKeyframeProgress;
    _overallProgress = overallProgress;
    return this;
  }

  double _startFrame;
  double get startFrame => _startFrame;

  double _endFrame;
  double get endFrame => _endFrame;

  T _startValue;
  T get startValue => _startValue;

  T _endValue;
  T get endValue => _endValue;

  double _linearKeyframeProgress;
  double get linearKeyframeProgress => _linearKeyframeProgress;

  double _interpolatedKeyframeProgress;
  double get interpolatedKeyframeProgress => _interpolatedKeyframeProgress;

  double _overallProgress;
  double get overallProgress => _overallProgress;

}