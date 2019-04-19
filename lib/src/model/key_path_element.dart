import './key_path.dart';

abstract class KeyPathElement {
  
  void resolveKeyPath(KeyPath keyPath, int depth, List<KeyPath> accumulator, KeyPath currentPartialKeyPath);
  void addValueCallback<T>(T property, dynamic callback);

}