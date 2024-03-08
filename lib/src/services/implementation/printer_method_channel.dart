import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer/src/models/printer_status.dart";

import "package:flutter_thermal_printer/src/services/printer_platform.dart";

class PrinterMethodChannel extends PrinterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel("flutter_thermal_printer");

  @override
  Future<PrinterStatus?> searchPrinter() async =>
      methodChannel.invokeMethod<PrinterStatus?>("searchPrinter");

  @override
  Future<bool> isConnected() async =>
      await methodChannel.invokeMethod<bool?>("isConnected") ?? false;

  @override
  Future<bool> isPrinting() async =>
      await methodChannel.invokeMethod<bool?>("isPrinting") ?? false;

  @override
  Future<PrinterStatus?> getStatus() async =>
      methodChannel.invokeMethod<PrinterStatus?>("getStatus");

  @override
  Future<PrintJobResult> print(PrintJobResult request) async {
    request.orderPrintInfo.status = PrintState.printing;

    var result =
        await methodChannel.invokeMethod<bool?>("print", request.toJson()) ??
            false;

    if (result) {
      request.orderPrintInfo.status = PrintState.printed;
    } else {
      request.orderPrintInfo.status = PrintState.failed;
    }

    return request;
  }
}
