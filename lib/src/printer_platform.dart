import 'package:flutter_thermal_printer/src/printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class PrinterPlatform extends PlatformInterface {
  PrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static PrinterPlatform _instance = PrinterMethodChannel();

  static PrinterPlatform get instance => _instance;

  static set instance(PrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
