import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer/src/models/printer_status.dart";
import "package:flutter_thermal_printer/src/services/printer_interface.dart";
import "package:flutter_thermal_printer/src/services/printer_platform.dart";

class PrintFailure implements Exception {}

class Printer {
  Future<PrinterStatus?> searchPrinter() async =>
      PrinterPlatform.instance.searchPrinter();

  Future<bool> isConnected() async => PrinterPlatform.instance.isConnected();

  Future<bool> isPrinting() async => PrinterPlatform.instance.isPrinting();

  Future<PrinterStatus?> getStatus() async =>
      PrinterPlatform.instance.getStatus();

  Future<PrintJobResult> print(PrintJobRequest request) async =>
      PrinterInterface.instance.printRequest(request);

  PrintJobResult retryPrint(PrintJobResult request) =>
      PrinterInterface.instance.retryPrintRequest(request);
}
