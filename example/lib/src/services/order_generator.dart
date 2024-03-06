import "dart:math";

import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

/// Generates a random print job order.
///
/// Returns a [PrintJobRequest] object containing randomly
/// generated order information.
PrintJobRequest generateRandomOrder() => PrintJobRequest(
      orderInfo: OrderInfo(
        orderId: Random().nextInt(1000).toString(),
        products: List.generate(
          Random().nextInt(5) + 1,
          (index) => ProductInfo(
            name: "Product $index",
            quantity: Random().nextInt(5) + 1,
            price: Random().nextDouble() * 100,
          ),
        ),
      ),
      orderMetadata: OrderMetadata(
        userName: "Mark",
        shopName: "Lokaal Gemak Shop",
        orderDate: DateTime.now().subtract(
          Duration(
            minutes: Random().nextInt(10),
            days: Random().nextInt(2),
          ),
        ),
      ),
    );

/// Converts a [PrintJobRequest] into a [PrintJobResult].
///
/// This function takes a [PrintJobRequest] object and
/// creates a [PrintJobResult] object with the same order information,
/// metadata, and additional print information. The print information includes
/// the current timestamp and the status set to "inQueue".
///
/// Returns the created [PrintJobResult] object.
PrintJobResult toPrintJobResult(PrintJobRequest request) => PrintJobResult(
      orderInfo: request.orderInfo,
      orderMetadata: request.orderMetadata,
      orderPrintInfo: OrderPrintInfo(
        printedAt: DateTime.now(),
        status: PrintStatus.inQueue,
      ),
    );
