import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer/src/models/printer_status.dart";
import "package:flutter_thermal_printer/src/services/implementation/printer_method_channel.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

abstract class PrinterPlatform extends PlatformInterface {
  PrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static PrinterPlatform _instance = PrinterMethodChannel();

  static PrinterPlatform get instance => _instance;

  static set instance(PrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<PrinterStatus?> searchPrinter() {
    throw UnimplementedError("searchPrinter() has not been implemented.");
  }

  Future<bool> isConnected() {
    throw UnimplementedError("isConnected() has not been implemented.");
  }

  Future<bool> isPrinting() {
    throw UnimplementedError("isPrinting() has not been implemented.");
  }

  Future<PrinterStatus?> getStatus() {
    throw UnimplementedError("getStatus() has not been implemented.");
  }

  Future<PrintJobResult> print(PrintJobResult request) {
    throw UnimplementedError("print() has not been implemented.");
  }
}
