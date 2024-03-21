import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer_example/src/models/order_info.dart";
import "package:flutter_thermal_printer_example/src/models/product_info.dart";

OrderInfo generateBakeryOrder() => OrderInfo(
      shopName: "Bakkerij de Goudkorst",
      orderId: "#0001",
      products: [
        const ProductInfo(
          name: "Appelflap",
          quantity: 2,
          price: 1.50,
        ),
        const ProductInfo(
          name: "Krentenbol",
          quantity: 3,
          price: 0.75,
        ),
        const ProductInfo(
          name: "Croissant",
          quantity: 1,
          price: 1.25,
        ),
      ],
    );

OrderInfo generateButcherOrder() => OrderInfo(
      shopName: "Slagerij PuurVlees",
      orderId: "#0002",
      products: [
        const ProductInfo(
          name: "Rundergehakt",
          quantity: 1,
          price: 3.50,
        ),
        const ProductInfo(
          name: "Kipfilet",
          quantity: 2,
          price: 2.75,
        ),
        const ProductInfo(
          name: "Varkenshaas",
          quantity: 1,
          price: 4.25,
        ),
      ],
    );

OrderInfo generatePizzeriaOrder() => OrderInfo(
      shopName: "Pizzeria Ciao",
      orderId: "#0003",
      products: [
        const ProductInfo(
          name: "Pizza Margherita",
          quantity: 1,
          price: 6.50,
        ),
        const ProductInfo(
          name: "Pizza Pepperoni",
          quantity: 3,
          price: 7.25,
        ),
        const ProductInfo(
          name: "Spaghetti Bolognese",
          quantity: 1,
          price: 2.99,
        ),
      ],
    );

OrderInfo generateSnackbarOrder() => OrderInfo(
      shopName: "Cafeteria Roos",
      orderId: "#0004",
      products: [
        const ProductInfo(
          name: "Frietje met",
          quantity: 2,
          price: 2.99,
        ),
        const ProductInfo(
          name: "Kroket",
          quantity: 3,
          price: 1.50,
        ),
        const ProductInfo(
          name: "Kaassouffle",
          quantity: 1,
          price: 2.25,
        ),
      ],
    );

/// Generates a random print job request.
///
/// Returns a [PrintJobRequest] object containing randomly
/// generated order information.
PrintJobRequest generatePrintJobRequest(OrderInfo orderInfo) => PrintJobRequest(
      receiptDTO: ReceiptBuilder()
          .addText("Bedankt voor je bestelling bij ${orderInfo.shopName}!")
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
        ..set("OrderDate", DateTime.now())
        ..set("ShopName", orderInfo.shopName),
    );
