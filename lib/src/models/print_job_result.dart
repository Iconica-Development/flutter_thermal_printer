import "package:flutter_thermal_printer/src/models/orders/order_info.dart";
import "package:flutter_thermal_printer/src/models/orders/order_metadata.dart";
import "package:flutter_thermal_printer/src/models/orders/order_print_info.dart";

class PrintJobResult {
  const PrintJobResult({
    required this.orderInfo,
    required this.orderMetadata,
    required this.orderPrintInfo,
  });

  factory PrintJobResult.fromJson(Map<String, dynamic> json) => PrintJobResult(
        orderInfo: OrderInfo.fromJson(
          json["orderInfo"] as Map<String, dynamic>,
        ),
        orderMetadata: OrderMetadata.fromJson(
          json["orderMetadata"] as Map<String, dynamic>,
        ),
        orderPrintInfo: OrderPrintInfo.fromJson(
          json["orderPrintInfo"] as Map<String, dynamic>,
        ),
      );

  final OrderInfo orderInfo;
  final OrderMetadata orderMetadata;
  final OrderPrintInfo orderPrintInfo;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "orderInfo": orderInfo.toJson(),
        "orderMetadata": orderMetadata.toJson(),
        "orderPrintInfo": orderPrintInfo.toJson(),
      };
}
