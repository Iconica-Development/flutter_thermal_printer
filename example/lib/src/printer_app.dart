import "package:flutter/material.dart";
import "package:flutter_thermal_printer_example/src/ui/screens/homepage.dart";

class PrinterApp extends StatelessWidget {
  const PrinterApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Flutter Printer"),
          ),
          body: Homepage(),
        ),
      );
}
