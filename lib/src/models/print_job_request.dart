import "package:flutter_thermal_printer/src/models/orders/order_info.dart";
import "package:flutter_thermal_printer/src/models/orders/order_metadata.dart";

class PrintJobRequest {
  const PrintJobRequest({
    required this.orderInfo,
    required this.orderMetadata,
  });

  factory PrintJobRequest.fromJson(Map<String, dynamic> json) =>
      PrintJobRequest(
        orderInfo: OrderInfo.fromJson(
          json["orderInfo"] as Map<String, dynamic>,
        ),
        orderMetadata: OrderMetadata.fromJson(
          json["orderMetadata"] as Map<String, dynamic>,
        ),
      );

  final OrderInfo orderInfo;
  final OrderMetadata orderMetadata;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "orderInfo": orderInfo.toJson(),
        "orderMetadata": orderMetadata.toJson(),
      };
}
