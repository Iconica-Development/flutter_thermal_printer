import "dart:async";

import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer/src/models/printer_info.dart";
import "package:flutter_thermal_printer/src/services/printer_platform.dart";
import "package:flutter_thermal_printer/src/services/printer_service.dart";

class PrintFailure implements Exception {}

class PrinterImpl extends Printer {
  final _printerPlatform = PrinterPlatform();
  final _printerService = PrinterService();

  final _statusController = StreamController<PrinterStatus>.broadcast();

  @override
  Stream<PrinterStatus> get statusUpdates => _statusController.stream;

  /// Gets the best printer available.
  /// If there is a printer selected, it will return that printer.
  @override
  Future<PrinterStatus?> getPrinter() async {
    var status = await _printerPlatform.getPrinter();
    if (status != null) {
      _statusController.add(status);
    }
    return status;
  }

  /// This method will return a list of all the printers available.
  ///
  /// Do not overuse this method as it can be slow. It is recommended to
  /// use this method once, and let the user decide which printer to use.
  /// To let the user decide which printer to use, use the `setPrinter` method.
  @override
  Future<List<PrinterInfo>> getPrinters() async =>
      _printerPlatform.getPrinters();

  /// This method will retrieve the status of the printer.
  /// If a printer is set, it will return the status of that printer.
  /// If no printer is set, it will return the status of the best printer
  /// available.
  @override
  Future<PrinterStatus?> getStatus() async {
    var status = await _printerPlatform.getStatus();
    if (status != null) {
      _statusController.add(status);
    }
    return status;
  }

  /// This method checks to see if the printer is currently printing.
  @override
  Future<bool> isPrinting() async => _printerPlatform.isPrinting();

  /// This method sets the preferred printer.
  @override
  Future<void> setPrinter(String portName) async =>
      _printerPlatform.setPrinter(portName);

  /// This method starts printing.
  /// It tries to print on the preferred printer, but, if the printer is not
  /// set, it will print on the best printer available. It will first check
  /// for USB printers, then Bluetooth printers, and finally network printers.
  @override
  Future<PrintJobResult> executePrint(PrintJobRequest request) async {
    var result = await _printerService.printRequest(request);
    if (result.orderPrintInfo.status != PrintState.printed) {
      unawaited(getStatus());
    }
    return result;
  }

  /// This method will retry printing the order.
  /// Use this method if the order failed to print.
  ///
  /// Internally it already retries printing the order, so you don't need to
  /// call this method if the order failed to print. However, if you want to
  /// give the user the option to retry printing the order, you can use this
  /// method.
  @override
  PrintJobResult retryPrint(PrintJobResult request) =>
      _printerService.retryPrintRequest(request);
}
