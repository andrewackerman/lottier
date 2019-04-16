import './content_model.dart';
import '../../animation/content/content.dart';
import '../layer/layer_base.dart';

class ShapeGroup implements ContentModel {
  
  ShapeGroup(
    this.name,
    this.items,
    this.hidden,
  ) : assert(name != null),
      assert(hidden != null);

  final String name;
  final List<ContentModel> items;
  final bool hidden;

  @override
  Content toContent(LayerBase layer) {
    return ContentGroup(layer, this);
  }

}