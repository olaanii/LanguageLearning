import 'package:logger/logger.dart';

abstract class AppLogger {
  void logInfo(String message);
  void logWarning(String message);
  void logError(String message, [dynamic error, StackTrace? stackTrace]);
}

class AppLoggerImpl implements AppLogger {
  final Logger _logger;

  // You can customize the LogPrinter and options here for prod/dev
  AppLoggerImpl() : _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void logInfo(String message) {
    _logger.i(message);
  }

  @override
  void logWarning(String message) {
    _logger.w(message);
  }

  @override
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
