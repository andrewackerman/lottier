library lottier;

enum LoggerLevel {
  warning,
  error,
}

abstract class Logger {
  void log(LoggerLevel level, dynamic msg);
}

class NullLogger extends Logger {
  @override
  void log(LoggerLevel level, dynamic msg) {}
}

class ConsoleLogger extends Logger {
  @override
  void log(LoggerLevel level, dynamic msg) 
    => print('${level == LoggerLevel.warning ? "[WARNING]" : "[ERROR]"}: $msg');
}