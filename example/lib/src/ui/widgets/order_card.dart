import "package:flutter/material.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.order,
    super.key,
  });

  final PrintJobRequest order;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  order.orderMetadata.get("ShopName"),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Text("Print voorbeeld bon ${order.orderMetadata.get("OrderId")}"),
            ],
          ),
        ),
      );
}
