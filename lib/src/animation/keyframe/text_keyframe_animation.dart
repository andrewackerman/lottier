import './keyframe_animation.dart';
import '../../model/document_data.dart';
import '../../value/keyframe.dart';

class TextKeyframeAnimation extends KeyframeAnimation<DocumentData> {

  TextKeyframeAnimation(List<Keyframe<DocumentData>> keyframe) : super(keyframe);

  @override
  DocumentData getValue(Keyframe<DocumentData> keyframe, double keyframeProgress) {
    return keyframe.startValue;
  }

}