import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

PrintJobResult toPrintJobResult(PrintJobRequest request) => PrintJobResult(
      orderInfo: request.orderInfo,
      orderMetadata: request.orderMetadata,
      orderPrintInfo: OrderPrintInfo(status: PrintState.inQueue),
    );
