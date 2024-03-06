import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_thermal_printer/src/printer_platform.dart';

class PrinterMethodChannel extends PrinterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_thermal_printer');

  @override
  Future<String?> getPlatformVersion() async {
    var version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
