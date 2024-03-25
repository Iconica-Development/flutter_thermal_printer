import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

/// Order print info
/// This class provides the print status of an order.
class OrderPrintInfo {
  OrderPrintInfo({
    required this.status,
    this.printedAt,
  });

  /// Create an instance of [OrderPrintInfo] from a JSON object.
  factory OrderPrintInfo.fromJson(Map<String, dynamic> json) => OrderPrintInfo(
        status: PrintState.values.firstWhere(
          (PrintState e) => e.toString() == json["status"],
        ),
        printedAt: json["printedAt"] == null
            ? null
            : DateTime.parse(json["printedAt"] as String),
      );

  final DateTime? printedAt;
  PrintState status;

  /// Converts the order print info to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
        "status": status.toString(),
        "printedAt": printedAt?.toIso8601String(),
      };
}
