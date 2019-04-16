import './lottier_frame_info.dart';
import '../animation/keyframe/keyframe_animation_base.dart';

class LottierValueCallback<T> {

  final frameInfo = LottierFrameInfo<T>();
  KeyframeAnimationBase animation;

  LottierValueCallback();
  LottierValueCallback.value(this._value);

  T _value;
  T get value => _value;
  set value(T newValue) {
    _value = newValue;
    if (animation != null) {
      animation.notifyListeners();
    }
  }

  T internalGetValue(
    double startFrame,
    double endFrame,
    T startValue,
    T endValue,
    double linearKeyframeProgress,
    double interpolatedKeyframeProgress,
    double overallProgress,
  ) { 
    frameInfo.set(
      startFrame,
      endFrame,
      startValue,
      endValue,
      linearKeyframeProgress,
      interpolatedKeyframeProgress,
      overallProgress,
    );
    
    return _value;
  }

}