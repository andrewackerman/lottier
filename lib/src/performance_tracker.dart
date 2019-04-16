import './utility/mean_calculator.dart';
import './utility/pair.dart';

class PerformanceTracker {
  
  final _frameListeners = Set<FrameListener>();
  final _layerRenderTimes = <String, MeanCalculator>{};

  bool enabled = false;
  
  void recordRenderTime(String layerName, double millis) {
    if (!enabled) return;

    if (!_layerRenderTimes.containsKey(layerName)) {
      _layerRenderTimes[layerName] = MeanCalculator();
    }

    final calculator = _layerRenderTimes[layerName];

    calculator.add(millis);

    if (layerName == '__container') {
      for (var listener in _frameListeners) {
        listener.onFrameRendered(millis);
      }
    }
  }

  void addFrameListener(FrameListener listener) {
    _frameListeners.add(listener);
  }

  void removeFrameListener(FrameListener listener) {
    _frameListeners.remove(listener);
  }

  void clearRenderTimes() {
    _layerRenderTimes.clear();
  }

  void logRenderTimes() {
    if (!enabled) return;

    final sortedRenderTimes = getSortedRenderTimes();

    print('[Lottier] Render Times:');
    for (var layer in sortedRenderTimes) {
      print('[Lottier]\t\t${layer.first}: ${layer.second}ms');
    }
  }

  List<Pair<String, double>> getSortedRenderTimes() {
    if (!enabled) return [];

    final sortedRenderTimes = List<Pair<String, double>>(_layerRenderTimes.length);

    int idx = 0;
    for (var entry in _layerRenderTimes.entries) {
      sortedRenderTimes[idx] = Pair(entry.key, entry.value.mean);
      idx++;
    }

    sortedRenderTimes.sort((p1, p2) => p1.second.compareTo(p2.second));

    return sortedRenderTimes;
  }
}

abstract class FrameListener {
  void onFrameRendered(double renderTimeMs);
}