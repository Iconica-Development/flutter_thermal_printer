import "dart:math";

import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer_example/src/models/order_info.dart";
import "package:flutter_thermal_printer_example/src/models/product_info.dart";

/// Generates a random order information.
///
/// Returns an [OrderInfo] object containing randomly
/// generated order information.
OrderInfo generateRandomOrderInfo() => OrderInfo(
      orderId: Random().nextInt(1000).toString(),
      products: List.generate(
        Random().nextInt(5) + 1,
        (index) => ProductInfo(
          name: "Product $index",
          quantity: Random().nextInt(5) + 1,
          price: Random().nextDouble() * 100,
        ),
      ),
    );

/// Generates a random print job request.
///
/// Returns a [PrintJobRequest] object containing randomly
/// generated order information.
PrintJobRequest generatePrintJobRequest(OrderInfo orderInfo) => PrintJobRequest(
      receiptDTO: ReceiptBuilder()
          .addText("Bedankt voor je bestelling bij Bakkerij de Goudkorst!")
          .addSpacing(20)
          .addText("Je bestellingen:")
          .addSpacing(20)
          .addTable(
            List.of(
              [
                ["Product", "Aantal", "Prijs"],
                ["-------", "------", "-----"],
              ],
            ),
          )
          .addTable(
            orderInfo.products
                .map(
                  (product) => [
                    product.name,
                    product.quantity.toString(),
                    "€ ${product.roundedTotal}",
                  ],
                )
                .toList(),
          )
          .addSpacing(30)
          .addText("Totaal: € ${orderInfo.totalAmount.toStringAsFixed(2)}")
          .addSpacing(50)
          .addText("Volgende keer via onze app bestellen? Download de app!")
          .addSpacing(20)
          .addQRCode("https://www.iconica.app")
          .build(),
      orderMetadata: OrderMetadata()
        // Add any order metadata that you want to use in your own app.
        ..set("OrderInfo", orderInfo)
        ..set("OrderId", orderInfo.orderId)
        ..set("OrderDate", DateTime.now()),
    );
