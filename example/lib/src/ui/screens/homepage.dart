import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer_example/src/services/bluetooth_permission_service.dart";
import "package:flutter_thermal_printer_example/src/services/order_generator.dart";
import "package:flutter_thermal_printer_example/src/ui/screens/notification_page.dart";
import "package:flutter_thermal_printer_example/src/ui/widgets/print_order.dart";
import "package:permission_handler/permission_handler.dart";

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ListModel _listNotifier = ListModel();

  var _showBluetoothMessage = false;

  Future<void> _generateOrder(BuildContext context) async {
    var result = await requestBluetoothPermission();

    if (result != PermissionStatus.granted) {
      setState(() {
        _showBluetoothMessage = true;
      });
      return;
    }

    var randomOrder = generateRandomOrder();

    _listNotifier.add(await Printer.instance.executePrint(randomOrder));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var result = await requestBluetoothPermission();

      if (result.isGranted) {
        await Future.delayed(const Duration(seconds: 1));
        unawaited(Printer.instance.getPrinter());
      }
    });

    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: _listNotifier,
              builder: (BuildContext context, Widget? child) {
                var results = _listNotifier.items;

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    results.sort(
                      (a, b) => (a.orderMetadata.get("OrderDate") as DateTime)
                          .compareTo(
                        b.orderMetadata.get("OrderDate") as DateTime,
                      ),
                    );
                    return PrintOrder(order: results[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, top: 12),
            child: ElevatedButton(
              onPressed: () {
                unawaited(_generateOrder(context));
              },
              child: const Text("Generate test Order"),
            ),
          ),
          const NotificationPage(),
          if (_showBluetoothMessage)
            const Text(
              """
Please enable Bluetooth and Location permissions to use the printer""",
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
