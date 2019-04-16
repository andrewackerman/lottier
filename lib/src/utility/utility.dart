import 'dart:ui';

class Utility {

  static double get pixelRatio => window.devicePixelRatio;

  static bool isAtLeastVersion(int major, int minor, int patch, int minMajor, int minMinor, int minPatch) {
    if (major > minMajor) return true;
    if (major < minMajor) return false;

    if (minor > minMinor) return true;
    if (minor < minMinor) return false;

    return patch >= minPatch;
  }

}