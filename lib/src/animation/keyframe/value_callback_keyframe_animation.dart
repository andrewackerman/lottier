import './keyframe_animation_base.dart';
import '../../value/lottier_frame_info.dart';
import '../../value/lottier_value_callback.dart';
import '../../value/keyframe.dart';

class ValueCallbackKeyframeAnimation<K, A> extends KeyframeAnimationBase<K, A> {

  final frameInfo = LottierFrameInfo<A>();

  final A valueCallbackValue;

  ValueCallbackKeyframeAnimation(
    LottierValueCallback<A> valueCallback,
    this.valueCallbackValue,
  ) : super([]) {
    setValueCallback(valueCallback);
  }
  ValueCallbackKeyframeAnimation.empty(
    LottierValueCallback<A> valueCallback,
  ) : this(valueCallback, null);

  @override
  double get endProgress => 1;

  @override
  void notifyListeners() {
    if (valueCallback != null) {
      super.notifyListeners();
    }
  }

  @override
  A get value {
    return valueCallback?.internalGetValue(0, 0, valueCallbackValue, valueCallbackValue, progress, progress, progress);
  }

  @override
  A getValue(Keyframe<K> keyframe, double keyframeProgress) => value;

}