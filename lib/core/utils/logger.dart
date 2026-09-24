import 'package:flutter/foundation.dart';

/// Custom wrapper for unified logging. 
/// Consolidates debug printing to avoid polluting production builds.
abstract class AppLogger {
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
    }
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message');
    if (error != null) debugPrint('Error Details: $error');
    if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  }
}
