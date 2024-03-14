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
