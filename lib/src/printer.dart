import "dart:async";

import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer/src/printer_impl.dart";

class PrintFailure implements Exception {}

/// Printer interface
/// This class is used to interact with the printer.
/// It provides methods to search for printers, check the status of the printer,
/// and print documents.
///
/// This class is a singleton, and the instance can be accessed
/// using the `instance` getter.
class Printer {
  static final Printer _instance = PrinterImpl();

  static Printer get instance => _instance;

  /// This stream emits the status of the orders being printed.
  Stream<PrinterStatus> get statusUpdates =>
      throw UnimplementedError("statusUpdates() has not been implemented.");

  /// Gets the best printer available.
  /// If there is a printer selected, it will return that printer.
  Future<PrinterStatus?> getPrinter() async =>
      throw UnimplementedError("getPrinter() has not been implemented.");

  /// This method will return a list of all the printers available.
  ///
  /// Do not overuse this method as it can be slow. It is recommended to
  /// use this method once, and let the user decide which printer to use.
  /// To let the user decide which printer to use, use the `setPrinter` method.
  Future<List<PrinterInfo>> getPrinters() async =>
      throw UnimplementedError("getPrinters() has not been implemented.");

  /// This method will retrieve the status of the printer.
  /// If a printer is set, it will return the status of that printer.
  /// If no printer is set, it will return the status of the best printer
  /// available.
  Future<PrinterStatus?> getStatus() async =>
      throw UnimplementedError("getStatus() has not been implemented.");

  /// This method checks to see if the printer is currently printing.
  Future<bool> isPrinting() async =>
      throw UnimplementedError("isPrinting() has not been implemented.");

  /// This method sets the preferred printer.
  Future<void> setPrinter(String portName) async =>
      throw UnimplementedError("setPrinter() has not been implemented.");

  /// This method starts printing.
  /// It tries to print on the preferred printer, but, if the printer is not
  /// set, it will print on the best printer available. It will first check
  /// for USB printers, then Bluetooth printers, and finally network printers.
  Future<PrintJobResult> executePrint(PrintJobRequest request) async =>
      throw UnimplementedError("print() has not been implemented.");

  /// This method will retry printing the order.
  /// Use this method if the order failed to print.
  ///
  /// Internally it already retries printing the order, so you don't need to
  /// call this method if the order failed to print. However, if you want to
  /// give the user the option to retry printing the order, you can use this
  /// method.
  PrintJobResult retryPrint(PrintJobResult request) =>
      throw UnimplementedError("retryPrint() has not been implemented.");
}
