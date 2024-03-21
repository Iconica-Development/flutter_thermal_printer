import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer_example/src/services/printer_status_notification.dart";

class PopUpDialog extends StatelessWidget {
  PopUpDialog({required this.printerStatus, super.key});

  final PrinterStatusNotification _printerStatus = PrinterStatusNotification();

  final PrinterStatus printerStatus;

  @override
  Widget build(BuildContext context) {
    var message = _printerStatus.getPrinterStatus(printerStatus);
    if (message != null) {
      return AlertDialog(
        title: const Text("Printer Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              unawaited(Printer.instance.getStatus());
            },
            child: const Text("Scan again"),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
