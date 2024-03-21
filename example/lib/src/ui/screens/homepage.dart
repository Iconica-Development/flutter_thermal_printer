import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer_example/src/services/bluetooth_permission_service.dart";
import "package:flutter_thermal_printer_example/src/services/order_generator.dart";
import "package:flutter_thermal_printer_example/src/ui/screens/notification_page.dart";
import "package:flutter_thermal_printer_example/src/ui/widgets/order_card.dart";
import "package:permission_handler/permission_handler.dart";

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

  var _isPrinting = true;

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      var result = await requestBluetoothPermission();

      if (result.isGranted) {
        await Future.delayed(const Duration(seconds: 1));
        await Printer.instance.getPrinter();
      }

      setState(() {
        _isPrinting = false;
      });
    });

    Future<void> _buildReceipt(PrintJobRequest printJobRequest) async {
      setState(() {
        _isPrinting = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      await Printer.instance.executePrint(bakeryOrder);
      await Future.delayed(const Duration(seconds: 10));
      setState(() {
        _isPrinting = false;
      });
    }

    return Center(
      child: _isPrinting
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 3,
              ),
            )
          : Column(
              children: [
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
                const NotificationPage(),
              ],
            ),
    );
  }
}
