import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';

class OrderPrintInfo {
  OrderPrintInfo({
    required this.status,
    this.printedAt,
  });

  final PrintStatus status;
  final DateTime? printedAt;
}
