import "dart:async";
import "dart:collection";

import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer/src/services/converters/print_converter.dart";
import "package:flutter_thermal_printer/src/services/printer_interface.dart";
import "package:flutter_thermal_printer/src/services/printer_platform.dart";

class PrinterService extends PrinterInterface {
  final Queue<PrintJobResult> _queue = Queue<PrintJobResult>();

  bool isProcessingQueue = false;

  @override
  Future<PrintJobResult> printRequest(PrintJobRequest printJobRequest) async {
    var printJobResult = toPrintJobResult(printJobRequest);
    _addQueue(printJobResult);
    unawaited(_processQueue());
    return printJobResult;
  }

  @override
  PrintJobResult retryPrintRequest(PrintJobResult printJobResult) {
    _addQueue(printJobResult);
    unawaited(_processQueue());
    return printJobResult;
  }

  void _addQueue(PrintJobResult printJobResult) {
    printJobResult.orderPrintInfo.status = PrintState.inQueue;
    _queue.add(printJobResult);
  }

  Future<void> _processQueue() async {
    if (isProcessingQueue) {
      return;
    }

    if (!await PrinterPlatform.instance.isConnected()) {
      return;
    }

    isProcessingQueue = true;

    while (_queue.isNotEmpty) {
      if (await PrinterPlatform.instance.isPrinting()) {
        await Future.delayed(const Duration(seconds: 1));
        continue;
      }

      var nextPrintJob = _queue.removeFirst();
      var result = await PrinterPlatform.instance.print(nextPrintJob);

      if (result.orderPrintInfo.status != PrintState.printed) {
        _addQueue(result);
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    isProcessingQueue = false;
  }
}
