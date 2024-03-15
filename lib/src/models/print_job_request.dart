import "package:flutter_thermal_printer/src/models/orders/order_metadata.dart";
import "package:flutter_thermal_printer/src/models/receipt_dto.dart";

class PrintJobRequest {
  const PrintJobRequest({
    required this.receiptDTO,
    required this.orderMetadata,
  });

  final ReceiptDTO receiptDTO;
  final OrderMetadata orderMetadata;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "receiptInfo": receiptDTO.toJson(),
      };
}
