import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

class OrderPrintInfo {
  OrderPrintInfo({
    required this.status,
    this.printedAt,
  });

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

  Map<String, dynamic> toJson() => <String, dynamic>{
        "status": status.toString(),
        "printedAt": printedAt?.toIso8601String(),
      };
}
