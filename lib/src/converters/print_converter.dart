import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

/// Converts a [PrintJobRequest] to a [PrintJobResult].
PrintJobResult toPrintJobResult(PrintJobRequest request) => PrintJobResult(
      receiptDTO: request.receiptDTO,
      orderMetadata: request.orderMetadata,
      orderPrintInfo: OrderPrintInfo(status: PrintState.inQueue),
    );
