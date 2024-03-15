import "package:flutter_thermal_printer/src/models/enums/receipt_data.dart";
import "package:pair/pair.dart";

class ReceiptDTO {
  List<Pair<ReceiptData, dynamic>> data = List.empty();

  List<Map<String, String>> toJson() {
    var transformedData = data
        .map(
          (e) => e.transform(
            (key, value) {
              if (value is String) {
                return {
                  "type": key.name,
                  "value": value,
                };
              } else if (value is List<List<String>>) {
                return {
                  "type": key.name,
                  "value": value.toString(),
                };
              } else {
                throw const FormatException("Invalid type");
              }
            },
          ),
        )
        .toList();

    return transformedData;
  }
}
