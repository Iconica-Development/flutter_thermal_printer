import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_thermal_printer/flutter_thermal_printer.dart";

class PopUpDialog extends StatelessWidget {
  const PopUpDialog({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Printer Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              unawaited(Printer.instance.getStatus());
            },
            child: const Text("Scan again"),
          ),
        ],
      );
}
