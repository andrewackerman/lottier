import '../layer/layer_base.dart';
import '../../animation/content/content.dart';

abstract class ContentModel {
  Content toContent(LayerBase layer);
}