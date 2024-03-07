import "package:flutter/material.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer_example/src/services/order_generator.dart";
import "package:flutter_thermal_printer_example/src/ui/widgets/print_order.dart";

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final ListModel _listNotifier = ListModel();

  @override
  Widget build(BuildContext context) => Center(
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
                        (a, b) => a.orderMetadata.orderDate
                            .compareTo(b.orderMetadata.orderDate),
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
                  _listNotifier.add(toPrintJobResult(generateRandomOrder()));
                },
                child: const Text("Generate test Order"),
              ),
            ),
          ],
        ),
      );
}

class ListModel with ChangeNotifier {
  final List<PrintJobResult> _items = [];

  List<PrintJobResult> get items => _items;

  void add(PrintJobResult item) {
    _items.add(item);
    notifyListeners();
  }
}
