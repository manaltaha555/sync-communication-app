import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(), // Pretty print to console
  );

  // Log informational messages
  static void logInfo(String message) {
    _logger.i(message);
  }

  // Log warnings
  static void logWarning(String message) {
    _logger.w(message);
  }

  // Log errors
  static void logError(String message, dynamic error, stackTrace) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  // Log debug messages (for development)
  static void logDebug(String message) {
    _logger.d(message);
  }
}
