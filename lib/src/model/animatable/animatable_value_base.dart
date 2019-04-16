import './animatable_value.dart';
import '../../value/keyframe.dart';

abstract class AnimatableValueBase<V, O> implements AnimatableValue<V, O> {

  final List<Keyframe<V>> keyframes;

  AnimatableValueBase(this.keyframes);
  AnimatableValueBase.value(V value)
    : this([Keyframe.nonanimated(value)]);
  
  bool get isStatic => keyframes.isEmpty || (keyframes.length == 1 && keyframes.first.isStatic);

}