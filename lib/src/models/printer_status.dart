import "package:flutter_thermal_printer/src/models/enums/printer_state.dart";

class PrinterStatus {
  PrinterStatus({required this.state, required this.isRecoverable});

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

  PrinterState state;
  bool isRecoverable;

  bool? isOK() => state == PrinterState.ok;

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
