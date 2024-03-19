import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

/// A class that provides a message for the printer status.
///
/// This class provides a message for the printer status. The message
/// is based on the [PrinterState] of the printer status.
class PrinterStatusNotification {
  static const _unknownErrorMessage = """
Something unexpected happened to the printer.
  Try restarting the printer.""";

  /// Returns a message for the printer status.
  ///
  /// This method returns a message for the printer status based on the
  /// [PrinterState] of the printer status. If the printer status is
  /// [PrinterState.ok], the method returns `null`. If the printer status
  /// is anything other than [PrinterState.ok], the method returns a message
  /// based on the [PrinterState] of the printer status.
  String? getPrinterStatus(PrinterStatus status) => switch (status.state) {
        PrinterState.ok => null,
        PrinterState.notFound => status.getError() ?? _unknownErrorMessage,
        PrinterState.unknown => status.getError() ?? _unknownErrorMessage,
        PrinterState.offline => status.getError() ?? _unknownErrorMessage,
        PrinterState.coverOpen => status.getNotification(),
        PrinterState.cutterError => status.getError() ?? _unknownErrorMessage,
        PrinterState.highTemperatureError =>
          status.getError() ?? _unknownErrorMessage,
        PrinterState.voltageError => status.getError() ?? _unknownErrorMessage,
        PrinterState.paperJamError => status.getError() ?? _unknownErrorMessage,
        PrinterState.paperEmptyError =>
          status.getError() ?? _unknownErrorMessage,
        PrinterState.paperPositionError =>
          status.getError() ?? _unknownErrorMessage,
        PrinterState.paperNearEmptyNotification => status.getNotification(),
        PrinterState.cleaningNotification => status.getNotification(),
      };
}
