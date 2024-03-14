import "package:flutter/material.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";
import "package:flutter_thermal_printer_example/src/ui/widgets/pop_up_dialog.dart";

class NotificationPage extends StatefulWidget {
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) => StreamBuilder<PrinterStatus>(
        stream: Printer.instance.statusUpdates,
        builder: (context, snapshot) {
          if (snapshot.hasData && !_isDialogShowing) {
            _isDialogShowing = true;
            Future.microtask(
              () async {
                await showDialog(
                  context: context,
                  builder: (context) =>
                      PopUpDialog(printerStatus: snapshot.data!),
                );
                _isDialogShowing = false;
              },
            );
          }
          return const SizedBox.shrink();
        },
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
