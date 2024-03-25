import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

/// Print job result
/// This class provides the result of a print job.
/// Use this class to get the result of a print job.
///
/// Example:
/// ```dart
/// var printJobRequest = PrintJobRequest(
///  receiptDTO: receiptDTO,
///  orderMetadata: orderMetadata,
/// );
///
/// var printJobResult = await printer.print(printJobRequest);
///
/// // print current status of the print job
/// print(printJobResult.orderPrintInfo.status);
/// ```
class PrintJobResult {
  const PrintJobResult({
    required this.receiptDTO,
    required this.orderMetadata,
    required this.orderPrintInfo,
  });

  final ReceiptDTO receiptDTO;
  final OrderMetadata orderMetadata;
  final OrderPrintInfo orderPrintInfo;

  /// Create an instance of [PrintJobResult] from a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
        "receiptInfo": receiptDTO.toJson(),
        "orderPrintInfo": orderPrintInfo.toJson(),
      };
}
