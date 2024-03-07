import 'package:flutter_thermal_printer/src/models/orders/order_info.dart';
import 'package:flutter_thermal_printer/src/models/orders/order_metadata.dart';
import 'package:flutter_thermal_printer/src/models/orders/order_print_info.dart';

class PrintJobResult {
  PrintJobResult({
    required this.orderInfo,
    required this.orderMetadata,
    required this.orderPrintInfo,
  });

  final OrderInfo orderInfo;
  final OrderMetadata orderMetadata;
  final OrderPrintInfo orderPrintInfo;
}
