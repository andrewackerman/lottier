library lottier;

import 'dart:ui';

import './value/image_asset.dart';
import './model/layer/layer.dart';
import './model/marker.dart';
import './value/font.dart';
import './model/font_character.dart';
import './performance_tracker.dart';

class LottierComposition {

  final performanceTracker = PerformanceTracker();
  final _warnings = Set<String>();

  Map<String, List<Layer>> _precomps;
  Map<String, LottierImageAsset> _images;
  Map<String, Font> _fonts;
  List<Marker> _markers;
  Map<int, FontCharacter> _characters;
  Map<int, Layer> _layerMap;
  List<Layer> _layers;
  Rect _bounds;
  double _startFrame;
  double _endFrame;
  double _frameRate;
  bool hasDashPattern;

  int maskAndMatteCount = 0;

  void initialize({
    Rect bounds,
    double startFrame,
    double endFrame,
    double frameRate,
    List<Layer> layers,
    Map<int, Layer> layerMap,
    Map<String, List<Layer>> precomps,
    Map<String, LottierImageAsset> images,
    Map<int, FontCharacter> characters,
    Map<String, Font> fonts,
    List<Marker> markers,
  }) {
    _bounds = bounds;
    _startFrame = startFrame;
    _endFrame = endFrame;
    _frameRate = frameRate;
    _layers = layers;
    _layerMap = layerMap;
    _precomps = precomps;
    _images = images;
    _characters = characters;
    _fonts = fonts;
    _markers = markers;
  }

  void addWarning(String warning) {
    print('[Lottier] $warning');
    _warnings.add(warning);
  }

  List<String> get warnings => _warnings.toList();
  Rect get bounds => _bounds;
  double get startFrame => _startFrame;
  double get endFrame => _endFrame;
  double get frameRate => _frameRate;
  List<Layer> get layers => _layers;
  Map<int, FontCharacter> get characters => _characters;
  Map<String, Font> get fonts => _fonts;
  List<Marker> get markers => _markers;

  void setPerformanceTrackingEnabled(bool enabled) => performanceTracker.enabled = enabled;

  Layer layerModelForId(int id) => _layerMap[id];
  List<Layer> precompsForId(int id) => _precomps[id];
  Marker getMarker(String name) => _markers.firstWhere((m) => m.equalsName(name), orElse: () => null);

  double get duration => durationFrames / frameRate * 1000;
  double get durationFrames => _endFrame - _startFrame;

  bool get hasImages => _images.isNotEmpty;
  Map<String, LottierImageAsset> get images => _images;
}