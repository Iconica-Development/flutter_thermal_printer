import "package:flutter_thermal_printer/src/models/orders/order_metadata.dart";
import "package:flutter_thermal_printer/src/models/receipt_dto.dart";

/// A class for requesting a print job.
/// This class provides the receipt and order metadata for a print job.
/// Use this class to request a print job.
///
/// Example:
/// ```dart
/// var printJobRequest = PrintJobRequest(
///  receiptDTO: receiptDTO,
///  orderMetadata: orderMetadata,
/// );
///
/// var printJobResult = await printer.print(printJobRequest);
/// ```
class PrintJobRequest {
  const PrintJobRequest({
    required this.receiptDTO,
    required this.orderMetadata,
  });

  final ReceiptDTO receiptDTO;
  final OrderMetadata orderMetadata;

  /// Converts the print job request to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
        "receiptInfo": receiptDTO.toJson(),
      };
}
