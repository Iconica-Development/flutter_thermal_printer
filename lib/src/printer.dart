import 'package:flutter_thermal_printer/src/printer_platform.dart';

class Printer {
  Future<String?> getPlatformVersion() =>
      PrinterPlatform.instance.getPlatformVersion();
}
