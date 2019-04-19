library lottier;

enum LoggerLevel {
  debug,
  info,
  warning,
  error,
}

String _loggerLevelPrefix(LoggerLevel lvl) {
  switch (lvl) {
    case LoggerLevel.debug:
      return '[DEBUG]';
    case LoggerLevel.info:
      return '[INFO]';
    case LoggerLevel.warning:
      return '[WARNING]';
    case LoggerLevel.error:
      return '[ERROR]';
  }
  return null;
}

class Logger {
  static const String tag = 'Lottier';
  static bool isDebug = false;
  static const maxDepth = 20;

  static final loggedMessages = Set<Object>();

  static bool traceEnabled = false;
  static List<String> sections;
  static List<int> startTimeUs;
  static int traceDepth = 0;
  static int depthPastMaxDepth = 0;

  static void log(LoggerLevel level, dynamic msg, [bool ignoreLogged = false]) {
    if (!ignoreLogged && loggedMessages.contains(msg)) return;
    final indent = '  ' * traceDepth;
    final prefix = _loggerLevelPrefix(level);
    print('$tag: $indent$prefix$msg');
    if (!ignoreLogged) loggedMessages.add(msg);
  }

  static void debug(dynamic msg) => isDebug ? log(LoggerLevel.debug, msg) : null;
  static void info(dynamic msg) => log(LoggerLevel.info, msg);
  static void warn(dynamic msg) => log(LoggerLevel.warning, msg);
  static void error(dynamic msg) => log(LoggerLevel.error, msg);

  void setTraceEnabled(bool enabled) {
    if (traceEnabled == enabled) return;

    traceEnabled = enabled;
    if (traceEnabled) {
      sections = List<String>(maxDepth);
      startTimeUs = List<int>(maxDepth);
    }
  }

  static void beginSection(String section) {
    if (!traceEnabled) return;

    if (traceDepth == maxDepth) {
      depthPastMaxDepth++;
      return;
    }

    sections[traceDepth] = section;
    startTimeUs[traceDepth] = DateTime.now().microsecondsSinceEpoch;
  }

  static double endSection(String section) {
    if (depthPastMaxDepth > 0) {
      depthPastMaxDepth--;
      return 0;
    }

    if (!traceEnabled) {
      return 0;
    }

    traceDepth--;

    if (traceDepth == -1) {
      throw StateError('Can\'t end trace section. There are none.');
    }
    if (section != sections[traceDepth]) {
      throw StateError('Unbalanced trace call $section. Expected ${sections[traceDepth]}.');
    }

    return (DateTime.now().microsecondsSinceEpoch - startTimeUs[traceDepth]) / 1000;
  }
}