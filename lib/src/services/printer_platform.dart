import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:logging/logging.dart";

class PrinterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel("flutter_thermal_printer");

  final _logger = Logger("PrinterPlatform");

  Future<PrinterStatus?> getPrinter() async {
    dynamic result;

    try {
      result = await methodChannel.invokeMethod("getPrinter");
    } on PlatformException {
      _logger.warning("Failed to get best printer match.");
      return null;
    }

    if (result != null) {
      return getStatus();
    } else {
      return null;
    }
  }

  Future<List<PrinterInfo>> getPrinters() async {
    List<dynamic>? result;

    try {
      result = await methodChannel
          .invokeMethod<List<Map<String, dynamic>>>("getPrinters");
    } on PlatformException {
      _logger.warning("Failed to get printers.");
      return [];
    }

    var printerInfoList = <PrinterInfo>[];
    if (result != null) {
      for (var item in result) {
        printerInfoList.add(PrinterInfo.fromJson(item));
      }
    }
    return printerInfoList;
  }

  Future<PrinterStatus?> getStatus() async {
    var result = await methodChannel.invokeMethod("getStatus");
    return result != null
        ? PrinterStatus.fromJson(Map<String, dynamic>.from(result))
        : null;
  }

  Future<bool> isPrinting() async =>
      await methodChannel.invokeMethod<bool?>("isPrinting") ?? false;

  Future<void> setPrinter(String portName) async =>
      methodChannel.invokeMethod("setPrinter", Map.from({portName: portName}));

  Future<PrintJobResult> executePrint(PrintJobResult request) async {
    request.orderPrintInfo.status = PrintState.printing;

    var result = await methodChannel.invokeMethod<bool?>(
          "print",
          request.toJson(),
        ) ??
        false;

    if (result) {
      request.orderPrintInfo.status = PrintState.printed;
    } else {
      request.orderPrintInfo.status = PrintState.failed;
    }

    return request;
  }
}
