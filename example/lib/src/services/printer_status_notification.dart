import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

class PrinterStatusNotification {
  static const _unknownErrorMessage = """
Something unexpected happened to the printer.
  Try restarting the printer.""";

  String? getPrinterStatus(PrinterStatus status) {
    switch (status.state) {
      case PrinterState.ok:
        return null;
      case PrinterState.notFound:
        return status.getError() ?? _unknownErrorMessage;
      case PrinterState.unknown:
        return status.getError() ?? _unknownErrorMessage;
      case PrinterState.offline:
        return status.getError() ?? _unknownErrorMessage;
      case PrinterState.coverOpen:
        return status.getNotification();
      case PrinterState.cutterError:
        return status.getError() ?? _unknownErrorMessage;
      case PrinterState.highTemperatureError:
        return status.getError() ?? _unknownErrorMessage;
      case PrinterState.voltageError:
        return status.getError() ?? _unknownErrorMessage;
      case PrinterState.paperJamError:
        return status.getError() ?? _unknownErrorMessage;
      case PrinterState.paperEmptyError:
        return status.getError() ?? _unknownErrorMessage;
      case PrinterState.paperPositionError:
        return status.getError() ?? _unknownErrorMessage;
      case PrinterState.paperNearEmptyNotification:
        return status.getNotification();
      case PrinterState.cleaningNotification:
        return status.getNotification();
    }
  }
}
