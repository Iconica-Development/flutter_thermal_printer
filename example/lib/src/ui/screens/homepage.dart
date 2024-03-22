import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer_example/src/services/order_generator.dart";
import "package:flutter_thermal_printer_example/src/ui/screens/notification_page.dart";
import "package:flutter_thermal_printer_example/src/ui/widgets/order_card.dart";

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final bakeryOrder = generatePrintJobRequest(generateBakeryOrder());

  final butcherOrder = generatePrintJobRequest(generateButcherOrder());

  final pizzeriaOrder = generatePrintJobRequest(generatePizzeriaOrder());

  final snackbarOrder = generatePrintJobRequest(generateSnackbarOrder());

  var _isPrinting = false;

  Future<void> _buildReceipt(PrintJobRequest printJobRequest) async {
    setState(() {
      _isPrinting = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    var result = await Printer.instance.executePrint(printJobRequest);
    if (result.orderPrintInfo.status != PrintState.printed) {
      await Future.delayed(const Duration(seconds: 10));
    }
    setState(() {
      _isPrinting = false;
    });
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            if (_isPrinting) ...{
              Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3,
                ),
              ),
            } else ...{
              InkWell(
                onTap: () async {
                  await _buildReceipt(bakeryOrder);
                },
                child: OrderCard(order: bakeryOrder),
              ),
              InkWell(
                onTap: () async {
                  await _buildReceipt(butcherOrder);
                },
                child: OrderCard(order: butcherOrder),
              ),
              InkWell(
                onTap: () async {
                  await _buildReceipt(pizzeriaOrder);
                },
                child: OrderCard(order: pizzeriaOrder),
              ),
              InkWell(
                onTap: () async {
                  await _buildReceipt(snackbarOrder);
                },
                child: OrderCard(order: snackbarOrder),
              ),
            },
            const NotificationPage(),
          ],
        ),
      );
}
