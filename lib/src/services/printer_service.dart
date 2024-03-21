import "dart:async";
import "dart:collection";

import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer/src/converters/print_converter.dart";
import "package:flutter_thermal_printer/src/services/printer_platform.dart";

class PrinterService {
  final PrinterPlatform _printerPlatform = PrinterPlatform();

  final Queue<PrintJobResult> _queue = Queue<PrintJobResult>();

  bool isProcessingQueue = false;

  Future<PrintJobResult> printRequest(PrintJobRequest printJobRequest) async {
    var printJobResult = toPrintJobResult(printJobRequest);
    _addQueue(printJobResult);
    unawaited(_processQueue());
    return printJobResult;
  }

  Future<PrintJobResult> retryPrintRequest(
    PrintJobResult printJobResult,
  ) async {
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

    isProcessingQueue = true;

    while (_queue.isNotEmpty) {
      if (await _printerPlatform.isPrinting()) {
        await Future.delayed(const Duration(seconds: 1));
        continue;
      }

      var nextPrintJob = _queue.removeFirst();
      var result = await _printerPlatform.executePrint(nextPrintJob);

      if (result.orderPrintInfo.status != PrintState.printed) {
        _addQueue(result);
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    isProcessingQueue = false;
  }
}
