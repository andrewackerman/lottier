import './key_path_element.dart';

class KeyPath {

  KeyPath(this.keys);
  KeyPath.copy(KeyPath keyPath)
    : keys = List.from(keyPath.keys) {
    _resolvedElement = keyPath.resolvedElement;
  }

  final List<String> keys;

  KeyPathElement _resolvedElement;
  KeyPathElement get resolvedElement => _resolvedElement;

  bool _isContainer(String key) => key == '__container';
  bool get _endsWithGlobstar => keys.last == '**';
  String keysToString() => keys.toString();

  KeyPath addKey(String key) {
    final newPath = KeyPath.copy(this);
    newPath.keys.add(key);
    return newPath;
  }

  KeyPath resolve(KeyPathElement element) {
    final path = KeyPath.copy(this);
    path._resolvedElement = element;
    return path;
  }

  bool matches(String key, int depth) {
    if (_isContainer(key)) {
      return true;
    }
    if (depth >= keys.length) {
      return false;
    }
    if (keys[depth] == key || 
        keys[depth] == '**' ||
        keys[depth] == '*') {
      return true;
    }
    return false;
  }

  int incrementDepthBy(String key, int depth) {
    if (_isContainer(key)) {
      return 0;
    }
    if (keys[depth] != '**') {
      return 1;
    }
    if (depth == keys.length - 1) {
      return 0;
    }
    if (keys[depth + 1] == key) {
      return 2;
    }
    return 0;
  }

  bool fullyResolvesTo(String key, int depth) {
    if (depth >= keys.length) {
      return false;
    }

    var isLastDepth = depth == keys.length - 1;
    String keyAtDepth = keys[depth];
    var isGlobstar = keyAtDepth == '**';

    if (!isGlobstar) {
      final matches = keyAtDepth == key || keyAtDepth == '*';
      return (isLastDepth || (depth == keys.length - 2 && _endsWithGlobstar)) && matches;
    }

    var isGlobstarButNextKeyMatches = !isLastDepth && keys[depth + 1] == key;
    if (isGlobstarButNextKeyMatches) {
      return depth == keys.length - 2 || (depth == keys.length - 3 && _endsWithGlobstar);
    }

    if (isLastDepth) {
      return true;
    }

    if (depth + 1 < keys.length - 1) {
      return false;
    }

    return keys[depth + 1] == key;
  }

  bool propagateToChildren(String key, int depth) {
    if (key == '__container') {
      return true;
    }
    return depth < keys.length - 1 || keys[depth] == '**';
  }

  @override
  String toString() => 'KeyPath{keys=$keys, resolved=${resolvedElement != null}}';

}