import "package:flutter/material.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer_example/src/services/datetime_formatter.dart";

class PrintOrder extends StatelessWidget {
  const PrintOrder({
    required this.order,
    super.key,
  });

  final PrintJobResult order;

  @override
  Widget build(BuildContext context) => Center(
        child: GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => _OrderDetailPage(order: order),
              ),
            );
          },
          child: _OrderCard(order: order),
        ),
      );
}

String _getOrderDate(DateTime date) => date.day == DateTime.now().day
    ? "Today at ${formatHourMinute(date)}"
    : "${formatDayMonthYear(date)} at ${formatHourMinute(date)}";

String _getOrderStatus(PrintJobResult order) =>
    order.orderPrintInfo.status.toString().split(".").last;

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
  });

  final PrintJobResult order;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Order: ${order.orderInfo.orderId}",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Text(
                "Order Date: ${_getOrderDate(order.orderMetadata.orderDate)}",
              ),
              Text(
                "Status: ${_getOrderStatus(order)}",
              ),
            ],
          ),
        ),
      );
}

class _OrderDetailPage extends StatelessWidget {
  const _OrderDetailPage({
    required this.order,
  });

  final PrintJobResult order;

  String _getOrderQuantityAndName(ProductInfo item) =>
      "${item.quantity}x ${item.name}";

  String _getOrderTotal(ProductInfo item) =>
      "@ ${item.roundedProductPrice} = ${item.roundedTotal}";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Order: ${order.orderInfo.orderId}"),
        ),
        body: SizedBox(
          child: Center(
            child: Column(
              children: [
                Text(
                  "Order Date: ${_getOrderDate(order.orderMetadata.orderDate)}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "Status: ${_getOrderStatus(order)}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Products:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (var item in order.orderInfo.products)
                  Text(
                    "${_getOrderQuantityAndName(item)} ${_getOrderTotal(item)}",
                  ),
                const SizedBox(height: 16.0),
                Text(
                  "Total: ${order.orderInfo.roundedTotalAmount}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
}
