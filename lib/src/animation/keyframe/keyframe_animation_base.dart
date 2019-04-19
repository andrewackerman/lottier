import 'package:lottier/src/animation/interpolator.dart';

import 'package:lottier/src/composition.dart';

import '../../value/lottier_value_callback.dart';
import '../../value/keyframe.dart';

abstract class AnimationListener {

  void onValueChanged();

}

class SimpleAnimationListener implements AnimationListener {

  final void Function() _callback;

  SimpleAnimationListener(this._callback);

  @override
  onValueChanged() => _callback();

}

abstract class KeyframeAnimationBase<K, A> {

  KeyframeAnimationBase(this.keyframes);
  
  final listeners = <AnimationListener>[];

  List<Keyframe<K>> keyframes;

  LottierValueCallback<A> valueCallback;

  Keyframe<K> _cachedKeyframe;

  Keyframe<K> _cachedGetValueKeyframe;
  double _cachedGetValueProgress = -1;
  A _cachedGetValue;

  
  double _progress = 0.0;
  double get progress => _progress;

  double _cachedStartDelayProgress;
  double get _startDelayProgress {
    if (_cachedStartDelayProgress == null) {
      _cachedStartDelayProgress = keyframes.isEmpty ? 0 : keyframes.first.startProgress;
    }
    return _cachedStartDelayProgress;
  }

  double _cachedEndProgress;
  double get _endProgress {
    if (_cachedEndProgress == null) {
      _cachedEndProgress = keyframes.isEmpty ? 1 : keyframes.last.startProgress;
    }
    return _cachedEndProgress;
  }

  bool _isDiscrete = false;
  void makeDiscrete() => _isDiscrete = true;

  void addUpdateListener(AnimationListener listener) {
    listeners.add(listener);
  }

  void setProgress(double progress) {
    assert(progress >= 0 && progress <= 1);

    if (keyframes.isEmpty) return;

    final previousKeyframe = currentKeyframe;
    if (progress < _startDelayProgress) {
      progress = _startDelayProgress;
    } else if (progress > _endProgress) {
      progress = _endProgress;
    }

    if (progress == this.progress) return;

    _progress = progress;

    final newKeyframe = currentKeyframe;

    if (previousKeyframe != newKeyframe || !newKeyframe.isStatic) {
      notifyListeners();
    }
  }

  void notifyListeners() {
    for (var listener in listeners) {
      listener();
    }
  }

  Keyframe<K> get currentKeyframe {
    if (_cachedKeyframe != null && _cachedKeyframe.containsProgress(progress)) {
      return _cachedKeyframe;
    }

    var keyframe = keyframes.last;
    if (progress < keyframe.startProgress) {
      for (int i = 0; i < keyframes.length; i++) {
        keyframe = keyframes[i];
        if (keyframe.containsProgress(progress)) {
          break;
        }
      }
    }

    _cachedKeyframe = keyframe;
    return keyframe;
  }

  double get linearCurrentKeyframeProgress {
    if (_isDiscrete) return 0;

    var keyframe = currentKeyframe;
    if (keyframe.isStatic) return 0;

    final progressIntoFrame = progress - keyframe.startProgress;
    final keyframeProgress = keyframe.endProgress - keyframe.startProgress;
    return progressIntoFrame / keyframeProgress;
  }

  double get interpolatedCurrentKeyframeProgress {
    var keyframe = currentKeyframe;
    if (keyframe.isStatic) return 0;

    return keyframe.interpolator.getInterpolation(linearCurrentKeyframeProgress);
  }

  double get startDelayProgress {
    if (_cachedStartDelayProgress == null) {
      _cachedStartDelayProgress = keyframes.isEmpty ? 0 : keyframes.first.startProgress;
    }
    return _cachedStartDelayProgress;
  }

  double get endProgress {
    if (_cachedEndProgress == null) {
      _cachedEndProgress = keyframes.isEmpty ? 1 : keyframes.last.endProgress;
    }
    return _cachedEndProgress;
  }

  A get value {
    final keyframe = currentKeyframe;
    final progress = interpolatedCurrentKeyframeProgress;
    if (valueCallback == null && keyframe == _cachedGetValueKeyframe && _cachedGetValueProgress == progress) {
      return _cachedGetValue;
    }

    _cachedGetValueKeyframe = keyframe;
    _cachedGetValueProgress = progress;
    final value = getValue(keyframe, progress);
    _cachedGetValue = value;

    return value;
  }

  void setValueCallback(LottierValueCallback<A> callback) {
    if (valueCallback != null) {
      valueCallback.animation = null;
    }

    valueCallback = callback;

    if (valueCallback != null) {
      valueCallback.animation = this;
    }
  }

  A getValue(Keyframe<K> keyframe, double keyframeProgress);

}