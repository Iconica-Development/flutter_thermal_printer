import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

class PrintJobResult {
  const PrintJobResult({
    required this.receiptDTO,
    required this.orderMetadata,
    required this.orderPrintInfo,
  });

  final ReceiptDTO receiptDTO;
  final OrderMetadata orderMetadata;
  final OrderPrintInfo orderPrintInfo;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "receiptInfo": receiptDTO.toJson(),
        "orderPrintInfo": orderPrintInfo.toJson(),
      };
}
