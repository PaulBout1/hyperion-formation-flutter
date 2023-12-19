import 'package:logger/logger.dart';

class _LoggerFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => true;
}

class _Logger {
  _Logger._()
      : _logger = Logger(
          printer: _logPrinter,
          filter: _LoggerFilter(),
        );

  final Logger _logger;

  static LogPrinter get _logPrinter {
    return PrettyPrinter(
      methodCount: 0, // number of method calls to be displayed
      errorMethodCount: 0, // number of method calls if stacktrace is provided
      lineLength: 50, // width of the output
    );
  }

  /// Log a message at level [Level.trace].
  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a message at level [Level.debug].
  void debug(
    dynamic message, {
    bool Function()? when,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (when == null || when()) {
      _logger.d(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log a message at level [Level.info].
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a message at level [Level.warning].
  void warn(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a message at level [Level.error].
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a message at level [Level.fatal].
  void wtf(
    dynamic message, {
    bool Function()? when,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (when == null || when()) {
      _logger.f(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

final logger = _Logger._();
