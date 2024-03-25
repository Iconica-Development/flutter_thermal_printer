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
  String? getNotification() => switch (state) {
        PrinterState.paperNearEmptyNotification =>
          "The printer is soon running out of paper.",
        PrinterState.coverOpen => "The printer cover is open.",
        PrinterState.cleaningNotification => "The printer should be cleaned.",
        _ => null
      };

  /// Returns an error message for the printer status.
  /// Error messages are messages that inform the user about critical
  /// issues with the printer. If there is a critical issue with the printer,
  /// the user should take action to resolve the issue. The printer will be
  /// unable to print until the issue is resolved.
  String? getError() => switch (state) {
        PrinterState.notFound => """
Could not find any printer. Make sure your printer is turned on.""",
        PrinterState.unknown => """
Something unexpected happened to the printer. Try restarting the printer.""",
        PrinterState.offline => "The printer is offline.",
        PrinterState.coverOpen => "The printer cover is open.",
        PrinterState.cutterError => "The cutter is not working properly.",
        PrinterState.highTemperatureError =>
          "The printer is too hot. Move the printer to a cooler place.",
        PrinterState.voltageError => """
The printer is not getting enough power. Check the power supply.""",
        PrinterState.paperJamError =>
          "The printer has a paper jam. Remove the jammed paper manually.",
        PrinterState.paperEmptyError =>
          "The printer is out of paper. Load paper into the printer.",
        PrinterState.paperPositionError => """
The paper roll is not positioned properly. Re-position the paper roll.""",
        _ => null
      };
}
