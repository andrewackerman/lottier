import '../document_data.dart';
import './animatable_value_base.dart';
import '../../value/keyframe.dart';
import '../../animation/keyframe/text_keyframe_animation.dart';

class AnimatableTextFrame extends AnimatableValueBase<DocumentData, DocumentData> {

  AnimatableTextFrame(List<Keyframe<DocumentData>> keyframes) : super(keyframes);

  @override
  TextKeyframeAnimation createAnimation() => TextKeyframeAnimation(keyframes);

}