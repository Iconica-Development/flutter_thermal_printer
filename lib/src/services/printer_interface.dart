import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer/src/services/implementation/printer_service.dart";

abstract class PrinterInterface {
  static final PrinterInterface _instance = PrinterService();

  static PrinterInterface get instance => _instance;

  Future<PrintJobResult> printRequest(PrintJobRequest printJobRequest) async {
    throw UnimplementedError("printRequest() has not been implemented.");
  }

  PrintJobResult retryPrintRequest(PrintJobResult printJobResult) {
    throw UnimplementedError("retryRequest() has not been implemented.");
  }
}
