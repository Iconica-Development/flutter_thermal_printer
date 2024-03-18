import "package:flutter_thermal_printer/src/models/enums/printer_state.dart";

/// A class for the status of a printer.
/// This class provides the state and recoverability of a printer.
/// Use this class to get the status of a printer.
///
/// Example:
/// ```dart
/// var printerStatus = await printer.getPrinterStatus();
///
/// if (printerStatus == null) {
///  return;
/// }
///
/// // get the state of the printer
/// print(printerStatus.state);
///
/// // get the recoverability of the printer
/// print(printerStatus.isRecoverable);
///
/// // get an error message for the printer status
/// print(printerStatus.getError());
///
/// // get a notification for the printer status
/// print(printerStatus.getNotification());
/// ```
class PrinterStatus {
  const PrinterStatus({required this.state, required this.isRecoverable});

  factory PrinterStatus.fromJson(Map<String, dynamic> json) {
    for (var value in PrinterState.values) {
      if (json["state"] == value.name) {
        return PrinterStatus(
          state: value,
          isRecoverable:
              json["isRecoverable"].toString().toLowerCase() == "true",
        );
      }
    }

    return PrinterStatus(
      state: PrinterState.unknown,
      isRecoverable: json["isRecoverable"].toString().toLowerCase() == "true",
    );
  }

  final PrinterState state;
  final bool isRecoverable;

  /// Returns `true` if the printer status is OK.
  bool? isOK() => state == PrinterState.ok;

  /// Returns a notification for the printer status.
  /// Notifications are messages that inform the user about the printer status.
  String? getNotification() {
    switch (state) {
      case PrinterState.paperNearEmptyNotification:
        return "The printer is soon running out of paper.";
      case PrinterState.coverOpen:
        return "The printer cover is open.";
      case PrinterState.cleaningNotification:
        return "The printer should be cleaned.";
      default:
        return null;
    }
  }

  /// Returns an error message for the printer status.
  /// Error messages are messages that inform the user about critical
  /// issues with the printer. If there is a critical issue with the printer,
  /// the user should take action to resolve the issue. The printer will be
  /// unable to print until the issue is resolved.
  String? getError() {
    switch (state) {
      case PrinterState.notFound:
        return """
Could not find any printer. Make sure your printer is turned on.""";
      case PrinterState.unknown:
        return """
Something unexpected happened to the printer. Try restarting the printer.""";
      case PrinterState.offline:
        return "The printer is offline.";
      case PrinterState.coverOpen:
        return "The printer cover is open.";
      case PrinterState.cutterError:
        return "The cutter is not working properly.";
      case PrinterState.highTemperatureError:
        return "The printer is too hot. Move the printer to a cooler place.";
      case PrinterState.voltageError:
        return """
The printer is not getting enough power. Check the power supply.""";
      case PrinterState.paperJamError:
        return "The printer has a paper jam. Remove the jammed paper manually.";
      case PrinterState.paperEmptyError:
        return "The printer is out of paper. Load paper into the printer.";
      case PrinterState.paperPositionError:
        return """
The paper roll is not positioned properly. Re-position the paper roll.""";
      default:
        return null;
    }
  }
}
