import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_thermal_printer/src/printer_method_channel.dart';
import 'package:flutter_thermal_printer/src/printer_platform.dart';

void main() {
  var initialPlatform = PrinterPlatform.instance;

  test('$PrinterMethodChannel is the default instance', () {
    expect(initialPlatform, isInstanceOf<PrinterMethodChannel>());
  });
}
