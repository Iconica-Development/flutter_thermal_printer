/// PrinterInfo model class
/// This class is used to represent the information of a printer.
/// The information of the printer can be used to determine the printer
/// model, port name, mac address, emulation, and port settings.
class PrinterInfo {
  PrinterInfo({
    required this.portName,
    required this.modelName,
    required this.macAddress,
    required this.emulation,
    required this.portSettings,
  });

  factory PrinterInfo.fromJson(Map<String, dynamic> json) => PrinterInfo(
        portName: json["portName"],
        modelName: json["modelName"],
        macAddress: json["macAddress"],
        emulation: json["emulation"],
        portSettings: json["portSettings"],
      );

  final String portName;
  final String modelName;
  final String macAddress;
  final String emulation;
  final String portSettings;
}
