class Marker {

  static const String _carriageReturn = '\r';

  final String name;
  final double startFrame;
  final double durationFrames;

  Marker(
    this.name,
    this.startFrame,
    this.durationFrames,
  );

  bool equalsName(String name) {
    if (this.name.toLowerCase() == name.toLowerCase()) {
      return true;
    }

    // Convenience removal of trailing newlines
    if (this.name.endsWith(_carriageReturn) && this.name.substring(0, this.name.length - 1).toLowerCase() == name.toLowerCase()) {
      return true;
    }

    return false;
  }

}