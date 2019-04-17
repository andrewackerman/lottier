library lottier;

enum LoggerLevel {
  info,
  warning,
  error,
}

class Logger {
  static void log(LoggerLevel level, dynamic msg) {
    final prefix = level == LoggerLevel.warning ? '[WARNING] ' : level == LoggerLevel.error ? '[ERROR] ' : ' ';
    print('Lottier: $prefix$msg');
  }

  static void info(dynamic msg) => log(LoggerLevel.info, msg);
  static void warn(dynamic msg) => log(LoggerLevel.warning, msg);
  static void error(dynamic msg) => log(LoggerLevel.error, msg);
}